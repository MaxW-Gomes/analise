curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar  wp;

./wp plugin install autoptimize --activate;

./wp plugin install "Disable XML-RPC Pingback" --activate;

./wp plugin install "Heartbeat Control" --activate;

./wp plugin install "rvg-optimize-database" --activate;

./wp plugin install imsanity --activate;

./wp plugin install "LiteSpeed Cache";
rm ./wp 
