# Google News api key: 99da284c213a46ecb176baabc4eb6b7c

from newsapi import NewsApiClient
from flask import Flask, render_template
import json

app = Flask(__name__)

@app.route('/')
def index():
    # init api client
    newsapi = NewsApiClient(api_key='99da284c213a46ecb176baabc4eb6b7c')

    # get top headlines
    top_headlines = newsapi.get_top_headlines()
    articles_top = top_headlines['articles']
    print(type(articles_top))

    index_remove = []
    for index, article in enumerate(articles_top):
        if article['urlToImage'] == None or article['urlToImage'] == '':
            index_remove.append(index)
        if article['title'] == None or article['title'] == '':
            index_remove.append(index)
        if article['description'] == None or article['description'] == '':
            index_remove.append(index)

    for index in index_remove:
        articles_top.pop(index)
    
    # get cnn headlines
    cnn_headlines = newsapi.get_top_headlines(sources='cnn')
    articles_cnn = cnn_headlines['articles']

    # get fox headlines
    fox_headlines = newsapi.get_top_headlines(sources='fox-news')
    articles_fox = fox_headlines['articles']

    # render
    return render_template('index.html', 
                            headline_card_url = articles_top[0]['url'], headline_card_urlToImage = articles_top[0]['urlToImage'], headline_card_title = articles_top[0]['title'], headline_card_description = articles_top[0]['description'],
                            gn_cnn_card_1_url = articles_cnn[0]['url'], gn_cnn_card_1_urlToImage = articles_cnn[0]['urlToImage'], gn_cnn_card_1_title = articles_cnn[0]['title'], gn_cnn_card_1_description = articles_cnn[0]['description'],
                            gn_cnn_card_2_url = articles_cnn[1]['url'], gn_cnn_card_2_urlToImage = articles_cnn[1]['urlToImage'], gn_cnn_card_2_title = articles_cnn[1]['title'], gn_cnn_card_2_description = articles_cnn[1]['description'],
                            gn_cnn_card_3_url = articles_cnn[2]['url'], gn_cnn_card_3_urlToImage = articles_cnn[2]['urlToImage'], gn_cnn_card_3_title = articles_cnn[2]['title'], gn_cnn_card_3_description = articles_cnn[2]['description'],
                            gn_cnn_card_4_url = articles_cnn[3]['url'], gn_cnn_card_4_urlToImage = articles_cnn[3]['urlToImage'], gn_cnn_card_4_title = articles_cnn[3]['title'], gn_cnn_card_4_description = articles_cnn[3]['description'],
                            gn_fox_card_1_url = articles_fox[0]['url'], gn_fox_card_1_urlToImage = articles_fox[0]['urlToImage'], gn_fox_card_1_title = articles_fox[0]['title'], gn_fox_card_1_description = articles_fox[0]['description'],
                            gn_fox_card_2_url = articles_fox[1]['url'], gn_fox_card_2_urlToImage = articles_fox[1]['urlToImage'], gn_fox_card_2_title = articles_fox[1]['title'], gn_fox_card_2_description = articles_fox[1]['description'],
                            gn_fox_card_3_url = articles_fox[2]['url'], gn_fox_card_3_urlToImage = articles_fox[2]['urlToImage'], gn_fox_card_3_title = articles_fox[2]['title'], gn_fox_card_3_description = articles_fox[2]['description'],
                            gn_fox_card_4_url = articles_fox[3]['url'], gn_fox_card_4_urlToImage = articles_fox[3]['urlToImage'], gn_fox_card_4_title = articles_fox[3]['title'], gn_fox_card_4_description = articles_fox[3]['description'],
                            )

if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
    # [END gae_python37_app]