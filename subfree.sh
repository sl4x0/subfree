#!/bin/bash

# Set the domain name
domain=$1

# Fetch subdomains from various sources concurrently
echo "https://rapiddns.io/subdomain/$domain?full=1#result
http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey
https://crt.sh/?q=%.$domain
https://crt.sh/?q=%.%.$domain
https://crt.sh/?q=%.%.%.$domain
https://crt.sh/?q=%.%.%.%.$domain
https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns
https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$domain
https://api.hackertarget.com/hostsearch/?q=$domain
https://certspotter.com/api/v0/certs?domain=$domain
https://spyse.com/target/domain/$domain
https://tls.bufferover.run/dns?q=$domain
https://dns.bufferover.run/dns?q=.$domain
https://urlscan.io/api/v1/search/?q=$domain
https://synapsint.com/report.php -d 'name=http%3A%2F%2F$domain'
https://jldc.me/anubis/subdomains/$domain
https://sonar.omnisint.io/subdomains/$domain" | xargs -n 1 -P 20 -I {} sh -c "curl -s {} | grep -o -E '([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.$domain'"

# Clean up the output by removing duplicates and sorting the lines alphabetically
sort -u tmp.txt -o tmp.txt

# Print the results
cat tmp.txt

# Clean up the temporary file
rm tmp.txt
