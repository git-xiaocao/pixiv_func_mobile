# Pixiv Func

# 新設計のUI

<br/>

[![latest release](https://img.shields.io/github/release/git-xiaocao/pixiv_func_mobile?label=latest%20release)](https://github.com/xiao-cao-x/pixiv_func_mobile/releases/latest)
![total downloads](https://img.shields.io/github/downloads/git-xiaocao/pixiv_func_mobile/total.svg?label=total%20downloads)
![total stars](https://img.shields.io/github/stars/git-xiaocao/pixiv_func_mobile?label=total%20stars)
![total forks](https://img.shields.io/github/forks/git-xiaocao/pixiv_func_mobile?label=total%20forks)

---

- Pixivサードパーティークライアント(モバイル)
- 状態管理フレームワークに`GetX`を採用
- コードは `flutter_lints` の仕様に厳格に準拠
- Flutterを初めて使う方に最適
- これは私の個人の趣味であり、同種の既存のプロジェクトとはなんら関係もありません
- このプロジェクトはFlutterの学習のためのFOSSです
- バグの発見や新機能の追加は気軽に[Issue](https://github.com/git-xiaocao/pixiv_func_mobile/issues/new)へ

---

[ヘルプとプレビューを見る(中国語のみ)](https://pixiv.xiaocao.moe/#/pixiv-func/mobile)

<!-- [QQグループ755467833](https://jq.qq.com/?_wv=1027&k=HHuqfLxy) -->

---

# 注意:これは正式リリースではありません

# どうやってコンパイルするの?

1. プロジェクトのディレクトリをターミナルで開く
2. `flutter pub get`を実行する
3. [build_release](./build_release)をターミナルにコピーペーストして実行

# I18n(国際化)のPR
以下の言語はこのリポジトリにPRを送ってください  
`简体中文` `English` `日本語` `Русский` 

その他の言語については以下リポジトリを参照してください  
[pixiv_func_i18n_expansion](https://github.com/git-xiaocao/pixiv_func_i18n_expansion)


# 機能面のPR

まず[Issue](https://github.com/git-xiaocao/pixiv_func_mobile/issues/new)を送ってから、PRを提出してください

# 機能一覧

| 名称 | 機能 | 状態 |
| - | - | - |
| おすすめ | イラスト 漫画 小説 ユーザー | 実装済 |
| ランキング | デイリー,デイリーR18,デイリー(男子/女子に人気),デイリーR18(男子/女子に人気) <br> ウィークリー,ウィークリーR18,ウィークリー(オリジナル/ルーキー) <br> マンスリー | 実装済 |
| 新着作品 | マイピク(イラスト 漫画 小説) <br> すき!(イラスト 漫画 小説) (すべて/公開/非公開) | 実装済 |
| 検索(ユーザーID) | おすすめタグ イラスト&漫画 小説 ユーザー 並び替え | 実装済 |
| 画像検索 | saucenao.com(ゲストユーザーは50回/日制限) | 実装済 |
| 閲覧 | イラスト(うごイラ含む)&漫画 小説 | 実装済 |
| 保存 | イラスト(うごイラ含む)&漫画 小説 | 改善予定(小説) |
| ユーザー閲覧 | 作品(イラスト 漫画 小説) <br> コレクション(イラスト&漫画 小説) <br> すき! 詳細情報 コレクション ヘッダー画像 | 実装済 |
| シェア | イラスト 漫画 小説 | 小説以外実装済 |
| コレクション すき! | イラスト&漫画 小説 ユーザー | 実装済 |
| コレクション用カスタムタグ | コレクションを長押し | 未実装 |
| ブラックリストタグ | 特定のタグをブロックするとリストに表示されなくなります(設定内から解除可能) | 実装済 |
| i18n | zh-CN ja-JP en_US ru_RU | 実装済 |
| テーマ | ダーク ライト システムのデフォルト | 実装済 |
| 複数アカウント | 複数アカウントへのログイン 切替可能 | 実装済 |
| ディープリンク(URLをアプリで開く) | イラスト ユーザー ブラウザでログイン | 実装済 |
| コメント閲覧 | 作品のコメントを閲覧 | 実装済 |
| コメント投稿 | コメント(投稿/返信/削除) | 実装済 |
| プロフィール設定 |  | 実装済 |
| ライブ視聴 | プロキシなしでライブ視聴([pixiv_live_proxy_server_dart](https://github.com/git-xiaocao/pixiv_live_proxy_server_dart)) コメント | 改善予定(コメント) |
| コメントの送信 |  | 未実装 |
| メッセージ | プライベートメッセージ 送信(テキスト/画像) メッセージ | 未実装 |
| ローカルリバースプロキシ | Webviewでのログイン | 実装済 |
| 作品のアップロード |  | 未実装 |
| pixivision |  | 検討中 |
| アカウントデータ | 暗号化 <br> クリップボードからのログイン(MIUIはクリップボードへのアクセス許可が必要) <br> アカウントへのログイン方法が不明な方のためのサポート | 実装済 |


# 謝辞

[![](https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.svg)](https://www.jetbrains.com/?from=git-xiaocao/pixiv_func_mobile)

> [JetBrains](https://www.jetbrains.com/?from=git-xiaocao/pixiv_func_mobile)社から、このオープンソースプロジェクトのために、以下のIDEの無償ライセンスを提供していただきました

[![](https://resources.jetbrains.com/storage/products/company/brand/logos/IntelliJ_IDEA.svg)](https://www.jetbrains.com/idea/?from=git-xiaocao/pixiv_func_mobile)

[![](https://resources.jetbrains.com/storage/products/company/brand/logos/GoLand.svg)](https://www.jetbrains.com/go/?from=git-xiaocao/pixiv_func_mobile)

[![](https://resources.jetbrains.com/storage/products/company/brand/logos/DataGrip.svg)](https://www.jetbrains.com/datagrip/?from=git-xiaocao/pixiv_func_mobile)  



