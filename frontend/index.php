<?php
$json = file_get_contents('http://python-backend:5000/api/news');
$news_data = json_decode($json, true);
?>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT News</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 960px;
            margin-top: 30px;
            margin-bottom: 30px;
        }
        .card {
            margin-bottom: 30px;
            border: none;
            box-shadow: 0 4px 8px rgba(0,0,0,.05);
            border-radius: .5rem;
        }
        .card-header {
            background-color: #007bff;
            color: white;
            font-weight: 700;
            border-bottom: none;
            border-top-left-radius: calc(.5rem - 1px);
            border-top-right-radius: calc(.5rem - 1px);
        }
        .list-group-item {
            border-left: none;
            border-right: none;
            padding: 15px 20px;
        }
        .list-group-item:first-child {
            border-top: none;
        }
        .list-group-item:last-child {
            border-bottom: none;
        }
        .list-group-item a {
            color: #333;
            text-decoration: none;
            font-size: 1.1rem;
            transition: color 0.2s ease;
        }
        .list-group-item a:hover {
            color: #007bff;
        }
        .read a {
            color: #888;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="my-4 text-center text-primary">最新ITニュース</h1>
        <?php foreach ($news_data as $site_title => $articles): ?>
            <div class="card">
                <div class="card-header">
                    <?php echo htmlspecialchars($site_title, ENT_QUOTES, 'UTF-8'); ?>
                </div>
                <ul class="list-group list-group-flush">
                    <?php foreach ($articles as $article): ?>
                        <li class="list-group-item">
                            <a href="<?php echo htmlspecialchars($article['link'], ENT_QUOTES, 'UTF-8'); ?>" target="_blank" data-link="<?php echo htmlspecialchars($article['link'], ENT_QUOTES, 'UTF-8'); ?>">
                                <?php echo htmlspecialchars($article['title'], ENT_QUOTES, 'UTF-8'); ?>
                            </a>
                        </li>
                    <?php endforeach; ?>
                </ul>
            </div>
        <?php endforeach; ?>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const readArticles = JSON.parse(localStorage.getItem('readArticles')) || [];
            const links = document.querySelectorAll('a[data-link]');

            links.forEach(link => {
                if (readArticles.includes(link.dataset.link)) {
                    link.parentElement.classList.add('read');
                }

                link.addEventListener('click', function() {
                    const articleLink = this.dataset.link;
                    if (!readArticles.includes(articleLink)) {
                        readArticles.push(articleLink);
                        localStorage.setItem('readArticles', JSON.stringify(readArticles));
                    }
                    this.parentElement.classList.add('read');
                });
            });
        });
    </script>
</body>
</html>
