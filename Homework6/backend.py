# Google News api key: 99da284c213a46ecb176baabc4eb6b7c

from newsapi import NewsApiClient
from flask import Flask, render_template
import json

app = Flask(__name__)

@app.route('/')
def index():
    # init api client
    newsapi = NewsApiClient(api_key='99da284c213a46ecb176baabc4eb6b7c')

    # /v2/top-headlines
    top_headlines = newsapi.get_top_headlines()
    article_top = top_headlines['articles'][0]
    

    return render_template('index.html', 
                            card_headline_urlToImage = article_top['urlToImage'],
                            card_headline_title = article_top['title'],
                            card_headline_description = article_top['description'])

@app.route('/get_top_headlines/')
def get_top_headlines():

    

    # /v2/top-headlines
    # top_headlines = newsapi.get_top_headlines()

    return "Hello World!"

if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
    # [END gae_python37_app]

# # /v2/top-headlines
# top_headlines = newsapi.get_top_headlines()
# # print(top_headlines)

# articles = top_headlines['articles']
# article_top = articles[0]
# print(article_top)
# article_
# article_urlToImage = article_top['urlToImage']
# # /v2/everything
# # all_articles = newsapi.get_everything()
# # all_articles = newsapi.get_everything(q='bitcoin',
# #                                       sources='bbc-news,the-verge',
# #                                       domains='bbc.co.uk,techcrunch.com',
# #                                       from_param='2019-12-01',
# #                                       to='2019-12-12',
# #                                       language='en',
# #                                       sort_by='relevancy',
# #                                       page=2)

# # /v2/sources

# # print(json_sources)
