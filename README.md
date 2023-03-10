# Subfree

Subfree is a tool that allows you to fetch subdomains using free open API resources without the need for an API key. This tool is ideal for those who are just starting with subdomain enumeration and do not have access to expensive tools or resources.

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/sl4x0
[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png

## Installation

Subfree can be installed using Git. Simply run the following command:

```console
git clone https://github.com/sl4x0/subfree.git
cd subfree
chmod +x subfree.sh
```

## Usage

To use Subfree, simply run the following command:

```bash
./subfree.sh <domain>
```
Replace <domain> with the domain you want to enumerate subdomains for.

Subfree uses free open API resources to fetch subdomains. This means that there is a limit to the number of subdomains that can be fetched per day. 
If you encounter any issues with the tool, please try open an [issue](https://github.com/sl4x0/subfree/issues).

> You can use this tool as a function inside your automation script, eg:
```console
function subfree(){
 # Input validation
    if [ $# -ne 1 ] || ! echo "$1" | grep -E '^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])\.([a-zA-Z]{2,})$' >/dev/null; then
        echo "Usage: $0 <domain>"
        exit 1
   ....
   ....
   ....
    echo "🎉 The subdomains have been saved to subfree.txt"

    # Clean up the temporary directory
    rm -r "$tmp_dir"
}

#Enumerate subdomains using Subfree
echo "🔍 Enumerating subdomains using Subfree..."
subfree "$domain"
cat subfree.txt > "$SUBDOMAINS_DIR/subfree.txt"
rm -rf subfree.txt
echo "✅ Done with Subfree enumeration."
```

## Keep updated
```console
git pull
```
## Contribution
You can contribute by suggest a new free API provider to fetch subdomains from! Just fork it.

## Credits

Subfree was inspired by a variety of open-source subdomain enumeration tools, including [OneForAll](https://github.com/shmilylty/OneForAll) and [Sublist3r](https://github.com/aboul3la/Sublist3r).

## To-do ✅
- [ ] Adding More Resources
- [ ] Overall Improvments
