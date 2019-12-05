# Expressive-writing
アイデアやノウハウを投稿したり、シェアするSNSです。

# 本番環境
https://expressive-writing.work/(現在停止中)
<br>テストユーザでログインできます。

# 使用技術
- Ruby 2.5.1
- Ruby on Rails 5.2.3
- MySQL
- SCSS
- Material(CSSフレームワーク) 
- MagicGrid(JavaScriptライブラリ) 
- Docker
- docker-compose
- AWS
  - Route53
  - VPC
  - EC2
  - ALB
  - ECS
  - ECR
  - RDS for MySQL
  - S3
  - ACM
- CircleCI
  - ecs-deploy
- RSpec
- Rubocup

# 機能一覧
- 投稿機能
  - 投稿機能
  - 下書き保存機能
  - 下書き自動保存機能(Ajax)
  - 投稿編集機能
  - 投稿削除機能
- コメント機能(Ajax)
  - コメント投稿機能
  - コメント編集機能
  - コメント削除機能
- ユーザ管理機能
  - マイページ機能
    - プロフィール編集機能
    - 下書き一覧表示機能
    - ユーザ一覧機能
        - ユーザ検索機能(Ajax)
- ユーザプロフィールページ
- ページネーション機能(kaminari)
  - Google検索と同様の「もっと見る」ボタン(Ajax)
- いいね機能
  - 投稿いいね機能
  - コメントいいね機能
- フォロー機能
- 新着情報通知機能
- お気に入り登録機能
- SNSシェア機能
- SNSログイン機能
- タグ機能
- 検索機能
- 未実装
  - 投稿タイマー機能
  - 検索機能の拡張
## テスト(Rspec)
  - 単体テスト
  - 統合テスト
## AWSアーキテクチャ図
![AWS Networking](https://user-images.githubusercontent.com/47965672/67170974-d8b53b80-f3ef-11e9-93b7-51d71cdf8ba8.png)
