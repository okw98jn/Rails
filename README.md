# My Food Diary
日々の自炊を簡単に管理し、楽しく自炊を続けるためのアプリです。  
[https://myfood-diary.herokuapp.com/](https://myfood-diary.herokuapp.com/)  
![screencapture-myfood-diary-herokuapp-2022-11-13-00_20_13](https://user-images.githubusercontent.com/104005833/201481383-32e2395d-8bea-42e4-9c2f-2af2d2759909.png)


## 制作した理由
- 毎日自炊をしていると飽きがきたりマンネリ化してしまう。  
- 気合を入れて作っても少し経つと、どんな料理を作ったのかあまり覚えていない。  
- 美味しく味付けできても細かい分量などを覚えていないため、毎回味が少し違ったりする。  
##### 上記のような悩みを少しでも解決したかったためこのアプリを作りました。

## 使用技術
- Ruby 2.7.3  
- Ruby on Rails 6.1.6  
- MySQL 8.0  
- Docker/Docker-compose   
- CircleCi(rubocop→Rspec→Herokuデプロイ）  
- RSpec   
- AWS S3(画像アップロード）  
- Heroku

## 機能一覧
- ユーザー登録、ログイン機能(devise)、ゲストログイン機能
- フォロー機能  
- レシピ投稿機能  
  - cocoonを使用しフォームをネスト
- カテゴリー機能  
- いいね機能   
- コメント機能  
- 通知機能   
  - 確認していない通知がある場合はヘッダーに件数を表示
  - フォローされた時
  - いいねされた時
  - コメントされた時
  - 自分がコメントした投稿に他のユーザーがコメントした場合
- 投稿検索機能  
  - 料理名、材料検索
  - カテゴリー検索
  - いいねランキング
  - コメントランキング
- 画像プレビュー機能  
  - ユーザーアイコン登録時
  - レシピ投稿時
- ページネーション機能(kaminari)

## 使用イメージ
ログインページ  
![スクリーンショット 2022-11-13 1 16 16](https://user-images.githubusercontent.com/104005833/201483656-0d5ef7d0-f4bc-4a60-922d-c3d1904c4155.png)  

マイページ  
![screencapture-myfood-diary-herokuapp-users-114-2022-11-13-01_09_34](https://user-images.githubusercontent.com/104005833/201483315-a5fd4d63-723e-4f3e-8c77-8a1313cc92f9.png)  

レシピ作成  
![screencapture-myfood-diary-herokuapp-posts-new-2022-11-13-01_00_34](https://user-images.githubusercontent.com/104005833/201482962-bba2dffd-36c7-4a16-b8db-289a5e6e5808.png)  

レシピ詳細ページ  
![screencapture-myfood-diary-herokuapp-posts-24-2022-11-13-01_14_06](https://user-images.githubusercontent.com/104005833/201483541-859b6b3d-3fab-448a-bb86-2a31236c2a95.png)  

検索画面  
![screencapture-myfood-diary-herokuapp-posts-4-search-category-2022-11-13-01_05_42](https://user-images.githubusercontent.com/104005833/201483131-78cfdd06-9caa-47b0-b2ad-e59500f2749a.png)  

通知画面  
![screencapture-myfood-diary-herokuapp-notifications-2022-11-13-01_11_05](https://user-images.githubusercontent.com/104005833/201483381-26987c00-6921-4e38-9180-ba5360520d29.png)  

## ER図
![ER](https://user-images.githubusercontent.com/104005833/201480042-8db42132-6e6e-4192-a798-162838afa972.png)

## Rspec
RequestSpec  
![request](https://user-images.githubusercontent.com/104005833/201480658-7a562ed9-da99-4b65-ad9f-0b630ef1e7d9.png)  
ModelSpec  
![model](https://user-images.githubusercontent.com/104005833/201480563-0879f5d9-af1a-44df-ab35-071b521c9120.png)  
SystemSpec  
![system](https://user-images.githubusercontent.com/104005833/201480388-6ee703a4-287f-464b-8614-aaef57ef29e7.png)
## 苦労した点
インフラ周りでのエラーにかなり苦戦しました。  
CircleCiでのRspec実行時にChromeをインストール出来なかったり、node.jsのバージョン違いでデプロイ出来ない等、他にもありましたが特にこの2点は時間がかかりました。  
最初の内はエラーに怯えていましたが、慣れてくると落ち着いてログを見て対応できるようになったのでいい経験になったかなと思います。

## 今後の課題 
- AWSでのデプロイ  
- React.jsやVue.jsでのフロント開発
