import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/comment.dart';
import 'package:pixiv_func_mobile/app/asset_manifest.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/services/account_service.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class IllustCommentContent extends StatelessWidget {
  final int id;

  const IllustCommentContent({Key? key, required this.id}) : super(key: key);

  String get controllerTag => '$runtimeType-$id';

  Widget buildCommentContent(Comment comment) {
    return Padding(
      //头像框的大小+边距
      padding: const EdgeInsets.only(left: 32 + 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (null != comment.stamp)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image.asset('assets/stamps/${comment.stamp!.stampId}.jpg'),
            )
          else if (comment.comment.isNotEmpty)
            ExtendedText(
              comment.comment,
              style: const TextStyle(fontSize: 14),
              specialTextSpanBuilder: EmojisSpecialTextSpanBuilder(multiple: 1.3),
            )
        ],
      ),
    );
  }

  Widget buildCommentItem(CommentTree commentTree) {
    final controller = Get.find<IllustCommentController>(tag: '$runtimeType-$id');
    final Widget widget;
    if (commentTree.children.isEmpty) {
      widget = ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => UserPage(id: commentTree.data.user.id)),
              child: PixivAvatarWidget(commentTree.data.user.profileImageUrls.medium, radius: 32),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(commentTree.data.user.name, fontSize: 12, isBold: true),
                TextWidget(Utils.dateFormat(DateTime.parse(commentTree.data.date)), fontSize: 10),
              ],
            ),
            const Spacer(),
            if (Get.find<AccountService>().currentUserId == commentTree.data.user.id)
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete),
                onPressed: () => controller.onCommentDelete(commentTree),
              ),
          ],
        ),
        subtitle: buildCommentContent(commentTree.data),
        trailing: () {
          if (commentTree.data.hasReplies) {
            if (commentTree.loading) {
              return CupertinoActivityIndicator(color: Get.theme.colorScheme.onSurface);
            } else {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.more_vert_outlined, color: Get.theme.colorScheme.primary, size: 24),
                onTap: () => controller.loadFirstReplies(commentTree),
              );
            }
          }
        }(),
      );
    } else {
      final children = [
        for (final commentTree in commentTree.children) buildCommentItem(commentTree),
        if (commentTree.loading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CupertinoActivityIndicator(color: Get.theme.colorScheme.onSurface)),
          )
        else if (commentTree.hasNext)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: InkWell(
              onTap: () => controller.loadNextReplies(commentTree),
              child: Row(
                children: const [
                  Icon(Icons.more_outlined),
                  SizedBox(width: 5),
                  TextWidget('加载更多...'),
                ],
              ),
            ),
          ),
      ];

      widget = ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
        childrenPadding: const EdgeInsets.only(left: 20),
        initiallyExpanded: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => UserPage(id: commentTree.data.user.id)),
              child: PixivAvatarWidget(commentTree.data.user.profileImageUrls.medium, radius: 32),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(commentTree.data.user.name, fontSize: 12, isBold: true),
                TextWidget(Utils.dateFormat(DateTime.parse(commentTree.data.date)), fontSize: 10),
              ],
            ),
            const Spacer(),
          ],
        ),
        subtitle: buildCommentContent(commentTree.data),
        children: children,
      );
    }
    return InkWell(
      onLongPress: () => controller.repliesCommentTree = commentTree,
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(IllustCommentController(id), tag: controllerTag);
    return GetBuilder<IllustCommentController>(
      tag: controllerTag,
      builder: (IllustCommentController controller) {
        return Column(
          children: [
            Flexible(
              child: DataContent(
                sourceList: controller.source,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, CommentTree item, bool visibility, int index) {
                  return buildCommentItem(item);
                },
              ),
            ),
            CommentInputWidget(
              resetReply: () => controller.repliesCommentTree = null,
              onSend: (text) => controller.onCommentAdd(text: text),
              onStampSend: (int id) => controller.onCommentAdd(stampId: id),
              label: controller.commentInputLabel,
            ),
          ],
        );
      },
    );
  }
}

class CommentInputWidget extends StatefulWidget {
  final VoidCallback resetReply;
  final void Function(String text) onSend;
  final void Function(int id) onStampSend;
  final String label;

  const CommentInputWidget({Key? key, required this.resetReply, required this.onSend, required this.onStampSend, required this.label})
      : super(key: key);

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  final GlobalKey<ExtendedTextFieldState> _key = GlobalKey<ExtendedTextFieldState>();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      //外面的ScrollController监听控制失去焦点收起键盘
      if (!_focusNode.hasFocus) {
        activeEmojiGird = activeStampGrid = false;
        _gridBuilderController.add(null);
      }
    });
    super.initState();
  }

  final StreamController<void> _gridBuilderController = StreamController<void>.broadcast();

  double _keyboardHeight = 0;
  double _preKeyboardHeight = 0;

  bool get showCustomKeyBoard => activeEmojiGird || activeStampGrid;

  bool activeEmojiGird = false;
  bool activeStampGrid = false;

  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool showingKeyboard = keyboardHeight > _preKeyboardHeight;
    _preKeyboardHeight = keyboardHeight;
    if ((keyboardHeight > 0 && keyboardHeight >= _keyboardHeight) || showingKeyboard) {
      activeEmojiGird = activeStampGrid = false;

      _gridBuilderController.add(null);
    }

    _keyboardHeight = max(_keyboardHeight, keyboardHeight);

    return WillPopScope(
      onWillPop: () async {
        if (_keyboardHeight > 0) {
          _focusNode.unfocus();
        }
        if (showCustomKeyBoard) {
          activeEmojiGird = activeStampGrid = false;
          _gridBuilderController.add(null);
          return false;
        }
        return true;
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.resetReply,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Icon(
                    Icons.reply_sharp,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ExtendedTextField(
                    onTap: () {
                      final primaryScrollController = PrimaryScrollController.of(context)!;
                      primaryScrollController.position.jumpTo(primaryScrollController.offset);
                    },
                    key: _key,
                    controller: _textEditingController,
                    minLines: 1,
                    maxLines: 5,
                    focusNode: _focusNode,
                    specialTextSpanBuilder: EmojisSpecialTextSpanBuilder(),
                    onSubmitted: (v) {
                      _textEditingController.text += '\n';
                    },
                    onChanged: (value) {
                      if (value.isEmpty != isEmpty) {
                        isEmpty = value.isEmpty;
                        _gridBuilderController.add(null);
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: widget.label,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      isDense: true,
                      prefix: const SizedBox(width: 5),
                      constraints: const BoxConstraints(maxHeight: 125, minHeight: 25),
                      border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                    ),
                  ),
                ),
              ),
              StreamBuilder<void>(
                stream: _gridBuilderController.stream,
                builder: (b, d) => Row(
                  children: [
                    if (keyboardHeight > 0 || showCustomKeyBoard)
                      GestureDetector(
                        onTap: () => onToolbarButtonActiveChanged(keyboardHeight, () {
                          activeEmojiGird = !activeEmojiGird;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Icon(
                            Icons.emoji_emotions,
                            color: activeEmojiGird ? Theme.of(context).colorScheme.primary : null,
                          ),
                        ),
                      ),
                    if (isEmpty && _preKeyboardHeight > 0 || showCustomKeyBoard)
                      GestureDetector(
                        onTap: () => onToolbarButtonActiveChanged(keyboardHeight, () {
                          activeStampGrid = !activeStampGrid;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Icon(
                            Icons.image,
                            color: activeStampGrid ? Theme.of(context).colorScheme.primary : null,
                          ),
                        ),
                      ),
                    if (!isEmpty)
                      ElevatedButton(
                        onPressed: () {
                          widget.onSend(_textEditingController.text);
                          _textEditingController.clear();
                        },
                        child: TextWidget(I18n.send.tr),
                      ),
                  ],
                ),
              ),
            ],
          ),
          StreamBuilder<void>(
            stream: _gridBuilderController.stream,
            builder: (BuildContext b, AsyncSnapshot<void> d) {
              return SizedBox(
                  height: showCustomKeyBoard ? _keyboardHeight - (Platform.isIOS ? mediaQueryData.padding.bottom : 0) : 0,
                  child: buildCustomKeyBoard());
            },
          ),
          StreamBuilder<void>(
            stream: _gridBuilderController.stream,
            builder: (BuildContext b, AsyncSnapshot<void> d) {
              return Container(
                height: showCustomKeyBoard ? 0 : keyboardHeight,
              );
            },
          ),
        ],
      ),
    );
  }

  void onToolbarButtonActiveChanged(double keyboardHeight, Function activeOne) {
    if (keyboardHeight > 0) {
      _keyboardHeight = keyboardHeight;
      SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    }

    activeEmojiGird = activeStampGrid = false;

    activeOne();

    _gridBuilderController.add(null);
  }

  Widget buildCustomKeyBoard() {
    if (!showCustomKeyBoard) {
      return Container();
    }
    if (activeEmojiGird) {
      return buildEmojiGird();
    }
    if (activeStampGrid) {
      return buildStampGird();
    }
    return Container();
  }

  void insertText(String text) {
    final TextEditingValue value = _textEditingController.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      _textEditingController.value = value.copyWith(
          text: newText, selection: value.selection.copyWith(baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      _textEditingController.value = TextEditingValue(text: text, selection: TextSelection.fromPosition(TextPosition(offset: text.length)));
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _key.currentState?.bringIntoView(_textEditingController.selection.base);
    });
    isEmpty = false;
    _gridBuilderController.add(null);
  }

  Widget buildEmojiGird() {
    return GridView.builder(
      //设置个controller避免滚动穿透
      controller: ScrollController(),
      //让GridView始终能滚动避免滚动穿透
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => insertText('(${assetManifest.emojis[index].name})'),
          child: Image.asset(assetManifest.emojis[index].fullPath),
        );
      },
      itemCount: assetManifest.emojis.length,
      padding: const EdgeInsets.all(5.0),
    );
  }

  Widget buildStampGird() {
    return GridView.builder(
      //设置个controller避免滚动穿透
      controller: ScrollController(),
      //让GridView始终能滚动避免滚动穿透
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => widget.onStampSend(int.parse(assetManifest.stamps[index].name)),
          child: Image.asset(assetManifest.stamps[index].fullPath),
        );
      },
      itemCount: assetManifest.stamps.length,
      padding: const EdgeInsets.all(5.0),
    );
  }
}

class EmojiText extends SpecialText {
  static const String flag = '(';
  final int start;
  final double? multiple;

  EmojiText(TextStyle? textStyle, {required this.start, this.multiple}) : super(EmojiText.flag, ')', textStyle);

  @override
  InlineSpan finishText() {
    final String key = toString();
    final String name = key.substring(1, key.length - 1);
    if (key.isNotEmpty && assetManifest.emojis.any((item) => name == item.name)) {
      return ImageSpan(
        AssetImage(assetManifest.emojis.singleWhere((item) => name == item.name).fullPath),
        actualText: key,
        imageWidth: (textStyle?.fontSize ?? 16) * (multiple ?? 1),
        imageHeight: (textStyle?.fontSize ?? 16) * (multiple ?? 1),
        start: start,
        margin: const EdgeInsets.all(2),
      );
    } else {
      return TextSpan(
        text: key,
      );
    }
  }
}

class EmojisSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  final double? multiple;

  EmojisSpecialTextSpanBuilder({this.multiple});

  @override
  SpecialText? createSpecialText(String flag, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, required int index}) {
    if (flag == '') {
      return null;
    }
    if (isStart(flag, "(")) {
      return EmojiText(textStyle, start: index - (EmojiText.flag.length - 1), multiple: multiple);
    }
    return null;
  }
}
