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
	rsync -CLrpgo $(JOURNALS_BUILD_PATH)/ build/jekyll/ --exclude=tmp
	rsync -CLrpgo $(JOURNALS_PATH) build/jekyll/ --filter=". rsync-text.txt"

	find build/jekyll/issue-* -name "*.markdown" | xargs bin/insert-yaml --if-missing=layout:article

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

local-post-generate:
	for i in $$(find dist/ -name "*.html");do \
		cat $$i \
			| perl -ne 's@<p>ATTR:@<p class="attribution">@sg;print;' \
			> .tmp; \
		mv .tmp $$i; \
	done

	# Change the H2's in the articles into formatted blocks. The
	# in-world elements are converted into lighter text, the OOW is
	# changed to serif.
	for i in $$(find dist/ -name "*.html"); do \
		if grep "BEGIN CONTENT" $$i > /dev/null; then \
			bin/format-journals-html $$i; \
		fi; \
	done
