# [System Design Interview - An Insider's Guide (Vol 1 and 2)](https://bytebytego.com/courses/system-design-interview)
このノートは書籍『System Design Interview』の [Vol 1 および Vol 2 第2版](https://www.goodreads.com/book/show/54109255-system-design-interview-an-insider-s-guide) に基づいています。

ノートはこちらでも閲覧できます: https://pagefy.io/system-design/system-design-interview-by-alex-xu

**注意:** このノートは作成途中です。


 * [第1章 - ゼロから数百万ユーザーへのスケール](./01.%20Scaling/)
 * [第2章 - 概算見積もり（Back-of-the-envelope Estimation）](./02.%20Back%20Of%20the%20Envelope%20Estimation/)
 * [第3章 - システム設計面接のためのフレームワーク](./03.%20System%20Design%20Framework/)
 * [第4章 - レートリミッターの設計](./04.%20Rate%20Limiter//)
 * [第5章 - コンシステントハッシュの設計](./05.%20Consistent%20Hashing/)
 * [第6章 - キーバリューストアの設計](./06.%20Key-Value%20Store/)
 * [第7章 - 分散システムにおける一意なID生成器の設計](./07.%20Unique-Id%20Generator/)
 * [第8章 - URL短縮サービスの設計](./08.%20URL%20Shortener/)
 * [第9章 - Webクローラーの設計](./09.%20Web%20Crawler/)
 * [第10章 - 通知システムの設計](./10.%20Notification%20System/)
 * [第11章 - ニュースフィードシステムの設計](./11.%20News%20Feed%20System/)
 * [第12章 - チャットシステムの設計](./12.%20Chat%20System/)
 * [第13章 - 検索オートコンプリートシステムの設計](./13.%20Search%20Autocomplete/)
 * [第14章 - YouTubeの設計](./14.%20Youtube/)
 * [第15章 - Google Driveの設計](./15.%20Google%20Drive/)
 * [第16章 - 近接サービス（Proximity Service）](./16.%20Proximity%20Service/)
 * [第17章 - 近くの友達（Nearby Friends）](./17.%20Nearby%20Friends/)
 * [第18章 - Google Mapsの設計](./18.%20Google%20Maps/)
 * [第19章 - 分散メッセージキュー](./19.%20Distributed%20Message%20Queue/)
 * [第20章 - メトリクス監視・アラートシステム](./20.%20Metrics%20Monitoring%20and%20Alerting%20System/)
 * [第21章 - 広告クリックイベント集計](./21.%20Ad%20Click%20Event%20Aggregation/)
 * [第22章 - ホテル予約システム](./22.%20Hotel%20Reservation%20System/)
 * [第23章 - 分散メールサービス](./23.%20Distributed%20Email%20Service/)
 * [第24章 - S3ライクなオブジェクトストレージ](./24.%20S3-like%20Object%20Storage/)
 * [第25章 - リアルタイムゲームリーダーボード](./25.%20Real-time%20Gaming%20Leaderboard/)
 * [第26章 - 決済システム](./26.%20Payment%20System/)
 * [第27章 - デジタルウォレット](./27.%20%20Digital%20Wallet/)
 * [第28章 - 証券取引所](./28.%20Stock%20Exchange/)


# 追加リソース

### レート制限
- [サーキットブレーカーアルゴリズム](https://martinfowler.com/bliki/CircuitBreaker.html)
- [Uberのレートリミッター](https://github.com/uber-go/ratelimit/blob/master/ratelimit.go)


### コンシステントハッシュ
- [Consistent Hashing](https://tom-e-white.com/2007/11/consistent-hashing.html)
- [CS168: Introduction and Consistent Hashing:]( http://theory.stanford.edu/~tim/s16/l/l1.pdf)
- [Apache Cassandra](http://www.cs.cornell.edu/Projects/ladis2009/papers/Lakshman-ladis2009.PDF)
- [Discordのスケーリング](https://blog.discord.com/scaling-elixir-f9b8e1e7c29b)
- [Google Maglev](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/44824.pdf)


### キーバリューストア
- [Amazon Dynamo](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf)
- [Cassandraのアーキテクチャ](https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/architecture/archIntro.html)
- [Google BigTableのアーキテクチャ](https://static.googleusercontent.com/media/research.google.com/en//archive/bigtable-osdi06.pdf)
- [Amazon Dynamo DBの内部構造](https://www.allthingsdistributed.com/2007/10/amazons_dynamo.html)
- [Amazon Dynamo DBの設計パターン](https://www.youtube.com/watch?v=HaEPXoXVf2k)
- [Amazon Dynamo DBの内部](https://www.youtube.com/watch?v=yvBR71D0nAQ)


### 一意なID生成器
- [Ticket Servers: Distributed Unique Primary Keys on the Cheap](https://code.flickr.net/2010/02/08/ticket-servers-distributed-unique-primary-keys-on-the-cheap)
- [Snowflake](https://blog.twitter.com/engineering/en_us/a/2010/announcing-snowflake.html)


### Webクローラー
- [Webクローリング](http://infolab.stanford.edu/~olston/publications/crawling_survey.pdf)
- [Googleのダイナミックレンダリング](https://developers.google.com/search/docs/guides/dynamic-rendering)



### チャットシステム
- [Discordは数十億件のメッセージをどう保存しているか](https://discord.com/blog/how-discord-stores-billions-of-messages)
- [Flannel: Slackをスケールさせるアプリケーションレベルのエッジキャッシュ](https://slack.engineering/flannel-an-application-level-edge-cache-to-make-slack-scale/)


### 検索オートコンプリート
- [Prefixyをどう構築したか](https://medium.com/@prefixyteam/how-we-built-prefixy-a-scalable-prefix-search-service-for-powering-autocomplete-c20f98e2eff1)
- [Prefix Hash Tree](https://people.eecs.berkeley.edu/~sylvia/papers/pht.pdf)


### YouTube
- [YouTubeのアーキテクチャ](http://highscalability.com/youtube-architecture)
- [YouTubeのスケーラビリティ 2012](https://www.youtube.com/watch?v=w5WVu624fY8)
- [大規模な動画トランスコーディング](https://www.egnyte.com/blog/2018/12/transcoding-how-we-serve-videos-at-scale/)
- [Facebookの動画ライブ配信](https://engineering.fb.com/ios/under-the-hood-broadcasting-live-video-to-millions/)
- [Netflixの大規模動画エンコーディング](https://netflixtechblog.com/high-quality-video-encoding-at-scale-d159db052746)
- [Netflixのショットベースエンコーディング](https://netflixtechblog.com/optimized-shot-based-encodes-now-streaming-4b9464204830)


### Google Drive
- [Differential Synchronization（差分同期）](https://neil.fraser.name/writing/sync/)
- [Differential Synchronization 動画](https://www.youtube.com/watch?v=S2Hp_1jqpY8)
- [Dropboxをどうスケールさせたか](https://www.youtube.com/watch?v=PE4gwstWhmc&feature=youtu.be)
