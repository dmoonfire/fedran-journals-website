STORIES_PATH = $(HOME)/src
JOURNALS_PATH = $(STORIES_PATH)/dmoonfire/journals-of-fedran/
JOURNALS_BUILD_PATH = $(JOURNALS_PATH)/build

SITE_DOMAIN = journals.fedran.com

default: clean generate

sync-repos:
	# Retrieve the various repositories associated with this site.
	if [ ! -d build/repos ];then mkdir build/repos; fi

	for i in $$(ls repos/* | grep -v "~" | cut -f 2- -d /); do \
		echo $$i; \
		if [ ! -d build/repos/$$i ];then git clone git@git.mfgames.com:dmoonfire/$$i.git build/repos/$$i > /dev/null; fi; \
		(cd build/repos/$$i && git pull > /dev/null); \
	done

upload: generate
	rsync -CLrpgo --delete dist/ fedran.com:~/sites/$(SITE_DOMAIN)/

local-copy-files:
	# Retrieve the various repositories associated with this site.
	if [ ! -d build/repos ];then mkdir build/repos; fi

	for i in $$(ls repos/* | grep -v "~" | cut -f 2- -d /); do \
		echo $$i; \
		./repos/$$i; \
	done

	rsync -CLrpgo $(JOURNALS_BUILD_PATH)/ build/jekyll/ --exclude=tmp
	rsync -CLrpgo $(JOURNALS_PATH) build/jekyll/ --filter=". rsync-text.txt"
	rm -rf build/jekyll/issue-00/resonance*

	find build/jekyll/issue-* -name "*.markdown" | xargs bin/insert-yaml --if-missing=layout:article
	rgrep -l '``` poetry' build/jekyll/issue-* | xargs bin/format-poetry-fence

	# for i in 00;do \
	# 	mv build/jekyll/issue-$$i.jpg build/jekyll/issue-$$i/index.jpg; \
	# 	convert build/jekyll/issue-$$i/index.jpg -scale x256 build/jekyll/issue-$$i/index-256.jpg; \
	# 	convert build/jekyll/issue-$$i/index.jpg -scale x512 build/jekyll/issue-$$i/index-512.jpg; \
	# 	if grep '<subject><subjectterm>Alpha</subjectterm></subject>' $(JOURNALS_PATH)/issue-$$i.xml > /dev/null; then \
	# 		find build/jekyll/issue-* -name "*.markdown" | xargs bin/insert-yaml --if-missing=editingStatus:alpha; \
	# 	fi; \
	# 	if grep '<subject><subjectterm>Beta</subjectterm></subject>' $(JOURNALS_PATH)/issue-$$i.xml > /dev/null; then \
	# 		find build/jekyll/issue-* -name "*.markdown" | xargs bin/insert-yaml --if-missing=editingStatus:beta; \
	# 	fi; \
	# done

	# mkdir -p build/jekyll/img
	# convert $(JOURNALS_BUILD_PATH)/issue-00.jpg -geometry 1819x600+500 build/jekyll/img/strip.jpg

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
