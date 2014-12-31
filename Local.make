STORIES_PATH = $(HOME)/stories
COVERS_PATH = $(HOME)/stories/covers
JOURNALS_PATH = $(STORIES_PATH)/dmoonfire/fedran/journals-of-fedran/
JOURNALS_BUILD_PATH = $(JOURNALS_PATH)/build

SITE_DOMAIN = journals.fedran.com

upload: generate
	rsync -CLrpgo --delete dist/ fedran.com:~/sites/$(SITE_DOMAIN)/
	rsync htaccess-ssl fedran.com:~/sites/$(SITE_DOMAIN)/.htaccess

local-copy-files:
	#$(MAKE) -C $(JOURNALS_STORIES_PATH)
	rm -rf build/jekyll/issue-*
	rsync -avp $(JOURNALS_BUILD_PATH)/ build/jekyll/ --exclude=tmp

	for i in 00;do \
		mv build/jekyll/issue-$$i.jpg build/jekyll/issue-$$i/index.jpg; \
		convert build/jekyll/issue-$$i/index.jpg -scale x256 build/jekyll/issue-$$i/index-256.jpg; \
		convert build/jekyll/issue-$$i/index.jpg -scale x512 build/jekyll/issue-$$i/index-512.jpg; \
	done

	# convert $(COVER_IMG) -scale 50% build/jekyll/img/cover.jpg
	# convert $(COVER_IMG) -scale x160 build/jekyll/img/cover-160.jpg
	# convert $(COVER_IMG) -scale x256 build/jekyll/img/cover-256.jpg
	# convert $(COVER_IMG) -scale x512 build/jekyll/img/cover-512.jpg

	# cp $(COVER_IMG) build/jekyll/img/cover-2554.jpg
