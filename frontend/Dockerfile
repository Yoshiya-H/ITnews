FROM php:8.2-apache

# Apacheのmod_rewriteを有効化
RUN a2enmod rewrite

# コンテナの/var/www/htmlに現在のディレクトリの内容をコピー
COPY . /var/www/html/

# ポート80を公開 (Apacheのデフォルトポート)
EXPOSE 80
