SITE_DOMAIN = sand-and-blood.fedran.com

upload: generate
	rsync -CLrpgo --delete dist/ moonfire.us:~/sites/$(SITE_DOMAIN)/
