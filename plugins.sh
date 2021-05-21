curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar  wp;

./wp plugin install "disable-xml-rpc-pingback" --activate;

./wp plugin install "heartbeat-control" --activate;

./wp plugin install "rvg-optimize-database" --activate;

./wp plugin install "litespeed-cache";
rm wp

