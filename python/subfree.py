#!/usr/bin/env python3

import argparse
import re
import tempfile
import requests
import concurrent.futures

def validate_domain(domain):
    """
    Validates the domain name using a regular expression.
    """
    pattern = re.compile(r'^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.([a-zA-Z]{2,})$')
    if not pattern.match(domain):
        raise ValueError('Invalid domain name')
    return domain

def fetch_subdomains(url, domain):
    """
    Fetches subdomains from a given URL and returns them as a set.
    """
    try:
        response = requests.get(url)
        response.raise_for_status()
        pattern = re.compile(rf'((?:[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.{domain})')
        return set(pattern.findall(response.text))
    except requests.exceptions.RequestException:
        return set()

def fetch_all_subdomains(domain):
    """
    Fetches subdomains from all URLs concurrently and returns them as a set.
    """
    urls = [
        f'https://rapiddns.io/subdomain/{domain}?full=1#result',
        f'http://web.archive.org/cdx/search/cdx?url=*.{domain}/*&output=text&fl=original&collapse=urlkey',
        f'https://crt.sh/?q=%.{domain}',
        f'https://crt.sh/?q=%.%.{domain}',
        f'https://crt.sh/?q=%.%.%.{domain}',
        f'https://crt.sh/?q=%.%.%.%.{domain}',
        f'https://otx.alienvault.com/api/v1/indicators/domain/{domain}/passive_dns',
        f'https://api.hackertarget.com/hostsearch/?q={domain}',
        f'https://urlscan.io/api/v1/search/?q={domain}',
        f'https://jldc.me/anubis/subdomains/{domain}',
    ]

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [executor.submit(fetch_subdomains, url, domain) for url in urls]
        subdomains = set()
        for future in concurrent.futures.as_completed(futures):
            subdomains |= future.result()

    return subdomains

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Enumerate subdomains for a given domain.')
    parser.add_argument('domain', type=validate_domain, help='the domain name to enumerate subdomains for')
    args = parser.parse_args()

    # Fetch subdomains from all sources
    subdomains = fetch_all_subdomains(args.domain)

    # Write subdomains to a file
    with tempfile.NamedTemporaryFile(mode='w+', delete=False) as tmp_file:
        tmp_file.writelines(f'{subdomain}\n' for subdomain in sorted(subdomains))
        tmp_file.flush()

    # Move temporary file to final output file
    output_file = f'{args.domain}.txt'
    try:
        with open(output_file, 'x') as file:
            pass
    except FileExistsError:
        pass
    with open(output_file, 'w') as file:
        with open(tmp_file.name, 'r') as tmp_file:
            file.writelines(tmp_file.readlines())

    print(f'Subdomains saved to {output_file}')

if __name__ == '__main__':
    main()
