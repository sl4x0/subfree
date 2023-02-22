#!/bin/bash

echo "
               __    ____             
   _______  __/ /_  / __/_______  ___ 
  / ___/ / / / __ \/ /_/ ___/ _ \/ _ \
 (__  ) /_/ / /_/ / __/ /  /  __/  __/
/____/\__,_/_.___/_/ /_/   \___/\___/ 
                                      @sl4x0
"
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
https://sonar.omnisint.io/subdomains/$domain" | xargs -n 1 -P 20 -I {} sh -c "curl -s {} | grep -o -E '([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.$domain'" > tmp.txt

# Clean up the output by removing duplicates and sorting the lines alphabetically
sort -u tmp.txt -o sorted_subs.txt

# Save the results to a file
cat sorted_subs.txt > subs.txt

# Print a message indicating that the results have been saved to the file
echo "The subdomains have been saved to subs.txt"

# Clean up the temporary files
rm tmp.txt sorted_subs.txt
