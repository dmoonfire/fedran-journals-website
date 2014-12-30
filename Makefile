#
# Variables
#

# If a file doesn't have a layout, Jekyll chokes. This allows us to
# give a default layout for those pages that don't explictly add it.
DEFAULT_LAYOUT = page

#
# Local Additions
#

# If you want to include any additional targets or use any of the
# hooks, then create a Local.make and put them there. Make will pick
# it up and include them. If the file is missing, the - allows the
# rest of the system to work.
-include Local.make

#
# Primary Targets
#

all: generate

clean:
	rm -rf build dist/*

reallyclean: clean
	rm -rf dist

prepare:
	if [ ! -d build/jekyll ];then mkdir -p build/jekyll;fi
	if [ ! -d dist ];then mkdir dist;fi

bootstrap: prepare
	if [ ! -d lib/bootstrap ]; then \
		echo "ERROR: lib/bootstrap is not populated"; \
		echo "ERROR: cd lib && git clone https://github.com/twbs/bootstrap.git"; \
		echo "ERROR: Stopping processing"; \
		false; \
		exit; \
	fi

	if [ ! -d build/jekyll/css ];then mkdir -p build/jekyll/css;fi
	rsync -a lib/bootstrap/less/ build/bootstrap/
	rsync -a less/ build/bootstrap
	lessc -x build/bootstrap/style.less > build/jekyll/css/style.css
	lessc -x build/bootstrap/bootstrap.less > build/jekyll/css/bootstrap.css

copy: bootstrap local-pre-copy
# Copy in the base Jekyll installation. This will include the
# configuration, layouts, includes, and related files that are
# specific to Jekyll itself.
	rsync -a jekyll/ build/jekyll/

# Copy in the various bootstrap elements.
	rsync -a lib/bootstrap/dist/css/ build/jekyll/css/
	rsync -a lib/bootstrap/dist/js/ build/jekyll/js/

# Copy all the files from the various components into the
# Jekyll-specific locations. These are simply organized to fit with
# our conventions while hiding most of the Jekyll stuff when it isn't
# needed.
#
# files:	Files that don't need to change or be views frequently. This
#     		is a good place to store JavaScript, CSS, or look-and-feel
#			elements as opposed to the bulk of the site.
# pages: 	Files that represent the content of the page.
#
# As a note, there really is no difference between any of these. It is
# just a convinent way of viewing the website and organizing it more
# than anything else.
	rsync -a files/ build/jekyll/
	rsync -a pages/ build/jekyll/

# Posts are special because Jekyll doesn't handle images in the post
# directories very well, but we like to put everything into one
# place. So, we copy out the files that will be processed into the
# _posts/ folder and then place the images in the correcponding
# location.
	rsync -a posts/ build/jekyll/_posts/

# local-copy-files hook. This pulls in any additional files from other
# locations.
	$(MAKE) local-copy-files

# Move all "file.markdown" into file/index.markdown for clean URLs.
	find build/jekyll/ -name "*.html" -o -name "*.markdown" \
		| grep -v '/_' \
		| xargs bin/move-to-directory-index

# Go through all the files and make sure they have a layout (because
# we don't want to require it) and they have fancy typography (curly
# quotes, em dashes).
	for f in $$(find build/jekyll -name "*.markdown"); do \
		cat $$f \
		| bin/normalize-markdown-yaml --layout=$(DEFAULT_LAYOUT) \
		| bin/apply-typography \
		> tmp.markdown; \
		mv tmp.markdown $$f; \
	done

# Create the taxonomies, collections, and breadcrumbs.
	bin/create-collections build/jekyll --root=build/jekyll
	bin/create-breadcrumbs build/jekyll
	bin/create-chapter-links build/jekyll

# Call the local-process-files hook. This is used to make changes to
# the various websites after they have been normalized and arranged in
# their "final" locations.
	$(MAKE) local-process-files

generate: copy bootstrap
	jekyll -s build/jekyll/ -d dist/
	$(MAKE) local-post-generate

#
# Hooks
#

# The hooks are basically targets that can be overridden to perform
# additional logic or processing.

local-pre-copy:
# This hook is used for any action that needs to be done before the
# "copy" target is called.

local-copy-files:

local-process-files:
# The local-process-files hook is useful for going through and adding
# missing YAML attributes to the page.

# For example, if your site has a flag for Flattr-able pages, then you
# can use this to ensure that the YAML element is there unless
# explictly added.
#	find build/jekyll/ -name "*.html" -o -name "*.markdown" \
#		| grep -v '/_' \
#		| xargs bin/insert-yaml --if-missing=showFlattr:true
#	find build/jekyll/_posts/ -name "*.html" -o -name "*.markdown" \
#		| xargs bin/insert-yaml --if-missing=showFlattr:true

local-post-generate:
# The local-post-generate hook is useful for going through the full
# generated file in the dist/ directory and performing additional
# processing.
	for i in $$(find dist/ -name "*.html");do \
		cat $$i \
			| perl -ne 's@<p>ATTR:@<p class="attribution">@sg;print;' \
			> .tmp; \
		mv .tmp $$i; \
	done

#
# Install Requirements
#

install-ubuntu-requirements:
	sudo apt-get install ruby1.9.1-dev 
	sudo gem install jekyll
