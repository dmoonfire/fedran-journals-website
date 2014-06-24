SITE_DOMAIN = sand-and-blood.fedran.com

upload: generate
	rsync -CLrpgo --delete dist/ moonfire.us:~/sites/$(SITE_DOMAIN)/
	rsync htaccess-ssl moonfire.us:~/sites/$(SITE_DOMAIN)/.htaccess
