# Google News api key: 99da284c213a46ecb176baabc4eb6b7c
# Google News api key: b0697e5b6a0d4e29a7bc690687ec538c

from newsapi import NewsApiClient
from flask import Flask, render_template, request
import json

app = Flask(__name__)

@app.route('/')
def index():
    app.send_static_file('javascript.js')
    return app.send_static_file('index.html')

@app.route('/fetch_headlines/<source>')
def fetch_headlines(source):
    # init api client
    newsapi = NewsApiClient(api_key='b0697e5b6a0d4e29a7bc690687ec538c')

    # get top headlines
    if 'cnn' in source:
        headlines = newsapi.get_top_headlines(sources='cnn')
    elif 'fox' in source:
        headlines = newsapi.get_top_headlines(sources='fox-news')
    else:
        headlines = newsapi.get_top_headlines()

    return headlines

@app.route('/fetch_source/<category>')
def fetch_source(category):
    
    # init api client
    newsapi = NewsApiClient(api_key='b0697e5b6a0d4e29a7bc690687ec538c')

    # get corresponding sources based on category
    if 'all' not in category:
        sources = newsapi.get_sources(category=category, language='en', country = 'us')
    else:
        sources = newsapi.get_sources(language='en', country = 'us')

    # with open('sources.json', 'w') as outfile:
    #     json.dump(sources, outfile)
    return sources

@app.route('/search', methods=['GET', 'POST'])
def search():

    # get form
    form = request.form
    search_input_keyword = form['search_input_keyword']
    search_input_from = form['search_input_from']
    search_input_to = form['search_input_to']
    search_select_source = form['search_select_source']
    
    # init api client
    newsapi = NewsApiClient(api_key='b0697e5b6a0d4e29a7bc690687ec538c')

    # get articles
    if 'all' in search_select_source:
        all_articles = newsapi.get_everything(q=search_input_keyword,
                                        from_param=search_input_from,
                                        to=search_input_to,
                                        language='en',
                                        sort_by='publishedAt',
                                        page_size=30)
    else:
        all_articles = newsapi.get_everything(q=search_input_keyword,
                                            sources=search_select_source,
                                            from_param=search_input_from,
                                            to=search_input_to,
                                            language='en',
                                            sort_by='publishedAt',
                                            page_size=30)

    with open('all_articles.json', 'w') as outfile:
        json.dump(all_articles, outfile)
    return all_articles

if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
    # [END gae_python37_app]