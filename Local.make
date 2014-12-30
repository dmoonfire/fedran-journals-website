SITE_DOMAIN = journals.fedran.com

upload: generate
	rsync -CLrpgo --delete dist/ moonfire.us:~/sites/$(SITE_DOMAIN)/
	rsync htaccess-ssl moonfire.us:~/sites/$(SITE_DOMAIN)/.htaccess

local-copy-files:
	# # Copy the sample chapters from the repo into the pages directory.
	# cp lib/stories/dmoonfire/fedran/sand-and-blood/chapters/chapter-0[1-7].markdown build/jekyll/

	# # Because of how epigraphs are written in the source document, we
	# # need to split them out for the Markdown processor to handle. We
	# # also add ATTR so we can style the paragraph later.
	# for i in build/jekyll/chapter*.markdown;do \
	# 	a=$$(echo $$i | cut -f 2 -d - | cut -f 1 -d . | sed 's@0@@'); \
	# 	cat $$i \
	# 		| perl -ne "s@Title: @Title: Chapter $$a: @;print;" \
	# 		| perl -ne 's@^(>.*) (---.*)@$$1\n\n> ATTR:$$2@g;print;' \
	# 		> a; \
	# 	mv a $$i; \
	# done

	# # bin/insert-yaml-relative build/jekyll/chapter-02.markdown next build/jekyll/chapter-01.markdown --chapter=2 --relative=../chapter-02
	# # bin/insert-yaml-relative build/jekyll/chapter-03.markdown next build/jekyll/chapter-02.markdown --chapter=3 --relative=../chapter-03
	# # bin/insert-yaml-relative build/jekyll/chapter-04.markdown next build/jekyll/chapter-03.markdown --chapter=4 --relative=../chapter-04
	# # bin/insert-yaml-relative build/jekyll/chapter-05.markdown next build/jekyll/chapter-04.markdown --chapter=5 --relative=../chapter-05
	# # bin/insert-yaml-relative build/jekyll/chapter-06.markdown next build/jekyll/chapter-05.markdown --chapter=6 --relative=../chapter-06
	# # bin/insert-yaml-relative build/jekyll/chapter-07.markdown next build/jekyll/chapter-06.markdown --chapter=7 --relative=../chapter-07

	# # bin/insert-yaml-relative build/jekyll/chapter-01.markdown previous build/jekyll/chapter-02.markdown --chapter=1 --relative=../chapter-01
	# # bin/insert-yaml-relative build/jekyll/chapter-02.markdown previous build/jekyll/chapter-03.markdown --chapter=2 --relative=../chapter-02
	# # bin/insert-yaml-relative build/jekyll/chapter-03.markdown previous build/jekyll/chapter-04.markdown --chapter=3 --relative=../chapter-03
	# # bin/insert-yaml-relative build/jekyll/chapter-04.markdown previous build/jekyll/chapter-05.markdown --chapter=4 --relative=../chapter-04
	# # bin/insert-yaml-relative build/jekyll/chapter-05.markdown previous build/jekyll/chapter-06.markdown --chapter=5 --relative=../chapter-05
	# # bin/insert-yaml-relative build/jekyll/chapter-06.markdown previous build/jekyll/chapter-07.markdown --chapter=6 --relative=../chapter-06

	# convert $(COVER_IMG) -scale 50% build/jekyll/img/cover.jpg
	# convert $(COVER_IMG) -scale x160 build/jekyll/img/cover-160.jpg
	# convert $(COVER_IMG) -scale x256 build/jekyll/img/cover-256.jpg
	# convert $(COVER_IMG) -scale x512 build/jekyll/img/cover-512.jpg

	# cp $(COVER_IMG) build/jekyll/img/cover-2554.jpg
