# Expressive-writing(作成中)
アイデアやノウハウを投稿したり、シェアするSNSです。

# 本番環境
https://expressive-writing.work/

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
  - 投稿編集機能
  - 投稿削除機能
- コメント機能(Ajax)
  - 投稿編集機能
  - 投稿削除機能
- ユーザ管理機能
- ページネーション機能(kaminari)

- 未実装
  - フォロー機能
  - いいね機能
  - 管理者機能

## テスト(Rspec)
  - 単体テスト
  - 統合テスト
  