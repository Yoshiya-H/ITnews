from flask import Flask, render_template, jsonify
from rss_util import get_news

app = Flask(__name__)

# @app.route('/')
# def index():
#     news = get_news()
#     return render_template('index.html', news=news)

@app.route('/api/news')
def api_news():
    news = get_news()
    return jsonify(news)


