import feedparser

def get_news():
    rss_urls = [
        "https://aws.amazon.com/jp/blogs/news/feed/",
        "https://aws.amazon.com/jp/blogs/news/tag/%E9%80%B1%E5%88%8Aaws/feed/",
        "https://feeds.arstechnica.com/arstechnica/index",
        "https://wired.jp/feed/rss",
        "https://rss.itmedia.co.jp/rss/2.0/ait.xml",
        "https://rss.itmedia.co.jp/rss/2.0/news_bursts.xml",
        "https://news.mynavi.jp/rss/techplus/whitepaper",
        "https://news.mynavi.jp/rss/techplus/enterprise",
    ]
    result = {}
    for url in rss_urls:
        feed = feedparser.parse(url)
        site_feed = feed.feed
        site_title = site_feed.title
        i = 0
        for entry in feed.entries:
            result.setdefault(site_title, []).append({
                "title": entry.title,
                "link": entry.link
            })
            i += 1
            if i > 9:
                break
    return result

get_news()