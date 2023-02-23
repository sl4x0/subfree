#!/bin/bash

# Input validation
if [ $# -ne 1 ] || ! echo "$1" | grep -E '^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.([a-zA-Z]{2,})$' >/dev/null; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Set the domain name
domain="$1"

# URLs to fetch subdomains from various sources
urls=(
    "https://rapiddns.io/subdomain/$domain?full=1#result"
    "http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey"
    "https://crt.sh/?q=%.$domain"
    "https://crt.sh/?q=%.%.$domain"
    "https://crt.sh/?q=%.%.%.$domain"
    "https://crt.sh/?q=%.%.%.%.$domain"
    "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns"
    "https://api.hackertarget.com/hostsearch/?q=$domain"
    "https://urlscan.io/api/v1/search/?q=$domain"
    "https://jldc.me/anubis/subdomains/$domain"
)

# Temporary directory for storing files
tmp_dir="$(mktemp -d)"

# Fetch subdomains from various sources concurrently
echo "🚀 Fetching subdomains from various sources concurrently..."
start_time=$(date +%s)
for url in "${urls[@]}"; do
    curl -s "$url" | grep -o -E '([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.'"$domain"'' > "$tmp_dir/tmp.txt" &
done
wait
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "✅ Subdomains fetched successfully in $elapsed_time seconds!"

# Clean up the output by removing duplicates and sorting the lines alphabetically
echo "🧹 Cleaning up the output by removing duplicates and sorting the lines alphabetically..."
start_time=$(date +%s)
sort -u "$tmp_dir"/* -o "$tmp_dir/sorted_subs.txt"
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "✅ Output cleaned up in $elapsed_time seconds!"

# Save the results to a file
mv "$tmp_dir/sorted_subs.txt" "subs.txt"

# Print a message indicating that the results have been saved to the file
echo "🎉 The subdomains have been saved to subs.txt"

# Clean up the temporary directory
rm -r "$tmp_dir"
