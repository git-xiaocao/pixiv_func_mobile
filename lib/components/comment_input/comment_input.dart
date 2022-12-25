import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:extra_hittest_area/extra_hittest_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/asset_manifest/asset_manifest.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/comment_input/emoji.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class CommentInputWidget extends StatefulWidget {
  final VoidCallback resetReply;
  final bool hasReply;
  final void Function(String text) onSend;
  final void Function(int id) onStampSend;
  final String label;

  const CommentInputWidget({
    Key? key,
    required this.resetReply,
    required this.hasReply,
    required this.onSend,
    required this.onStampSend,
    required this.label,
  }) : super(key: key);

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
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.hasReply)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetectorHitTestWithoutSizeLimit(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.resetReply,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Icon(
                          Icons.replay,
                        ),
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
                        _gridBuilderController.add(null);
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
                      if (_textEditingController.text.isEmpty && (_preKeyboardHeight > 0 || showCustomKeyBoard))
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
                      if (_textEditingController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onSend(_textEditingController.text);
                              _textEditingController.clear();
                            },
                            child: TextWidget(I18n.send.tr),
                          ),
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
