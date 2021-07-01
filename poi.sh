#!/bin/bash
# Tested on Ubuntu 16.04 
# @Author : Zerobyte-id
# @Github : github.com/zerobyte-id

uagent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/75.0.3770.90 Chrome/75.0.3770.90 Safari/537.36";
rm -Rf tmp-domain.txt
# Find Subdomains 
read -p "Input Domain >> " do;

curl -s "https://findsubdomains.com/search/subdomains?domain=${do}&page=1&per_page=100&domain=${do}" | sed 's/\\//g' | grep -Po '(?<=data-target=").*?(?=")' > tmp-domain.txt

# Checking domain
if [[ -z $(cat tmp-domain.txt) ]]; then
	echo "Kosong"
else
	for d in $(cat tmp-domain.txt);
	do
		# Checking DNS Cache Poisoning
		dnscp=$(curl -Ls -A "${uagent}" -m 3 -H "X-Forwarded-Host: zerobyte.id" "${d}")
		if [[ $dnscp =~ 'zerobyte.id' ]]; then
			echo "  ${d} => Vuln DNS Cache Poisoning"
			echo "${d}" >> vuln.txt
		else
			echo "  ${d} => Not Vuln"
		fi
	done
fi
rm -Rf tmp-domain.txt
