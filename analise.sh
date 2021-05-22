log="$1";


echo -e "10 IPs que mais acessaram:\n";

awk '{print $1}' $log | sort | uniq -dc | sort -nr | head;

echo -e  "\n\n10 URLs mais acessadas com o user-agent:\n";

awk -F\" '{print $2 " " $6}' $log | cut -d' ' -f2,4- | sort | uniq -c | sort -nr | head;

echo -e "\n\n 10 urls mais acessadas:\n";

awk -F\" '{print $2}' $log | awk '{print $2}' | sort | uniq -c | sort -nr | head;

echo -e "\n\n 10 URLs mais acessadas, ignorando query strings: \n";

awk -F\" '{print $2}' $log | awk -F'?' {'print $1'} | sort | uniq -c | sort -nr | head;

echo -e "\n\n 10 user-agents que mais acessaram o website: \n";

awk -F\" '{print $6}' $log | sort | uniq -c | sort -nr | head;

echo -e "\n\n 10 referer: \n";

awk -F\" '{print $4}' $log | sort | uniq -c | sort -nr | head;

echo -e "\n\n 10 response codes mais retornados: \n";

awk '{print $9}' $log | sort | uniq -c | sort -nr | head;

echo -e "\n\n Somando o tráfego:\n";

awk '{sum+=$10} END {print sum/1024/1024/1024 " GB"}' ${log};
