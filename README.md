# DMCMS migration

Upload news to Tumblr (~3 minutes)

    date ; dotenv ruby upload_news.rb ; date

Upload events (will reach daily photo upload limit) (~10 minutes)

    date ; dotenv ruby upload_events.rb ; date

Delete everything uploaded to Tumblr (to start over)

    dotenv ruby delete.rb

Generate events.html, copy-paste into /events

    dotenv ruby list_events.rb

Browse content with web browser

    dotenv bundle exec rackup

Compare cleaned news text with original

    dotenv bin/news <NEWS ID>

Dump MySQL tables

    dotenv bin/dump

Import MySQL tables

    dotenv bin/import

## `.env`

    database_url="mysql://root@localhost/klubbdinmamma"

    # Tumblr credentials
    blog_name=
    consumer_key=
    consumer_secret=
    oauth_token=
    oauth_token_secret=

    # MySQL credentials
    mysql_hostname=
    mysql_username=
    mysql_password=
    mysql_database=
    savepath=
