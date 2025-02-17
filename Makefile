DOCKER_IMAGE=book-builder
BOOK_MANIFEST=book.yaml

# Function to extract values from book.yaml
CHAPTERS=$(shell awk '/chapters:/ {flag=1; next} /^[^ ]/ {flag=0} flag {print $$2}' $(BOOK_MANIFEST))

build-image:
	docker build -t $(DOCKER_IMAGE) .

epub: ensure-chapters
	@docker run --rm -v "$(PWD)":/book $(DOCKER_IMAGE) pandoc -s \
		--toc \
		--toc-depth=1 \
		--metadata-file=$(BOOK_MANIFEST) \
		--variable subparagraph \
	  -f gfm+footnotes \
	  -t epub3 \
	  -o book.epub \
		preface.md \
	$(CHAPTERS)

pdf: preface.tex book.pdf

# Generate the preface.tex file
preface.tex: preface.md
	@docker run --rm -v "$(PWD)":/book $(DOCKER_IMAGE) pandoc \
	  -f gfm+footnotes \
		-t latex \
	  -o preface.tex \
	  --top-level-division=chapter \
	  preface.md

# Ensure all chapter files exist before building the book
.PHONY: ensure-chapters
ensure-chapters:
	@for chapter in $(CHAPTERS); do \
		if [ ! -f $$chapter ]; then \
			echo "Error: Missing chapter file: $$chapter"; \
			exit 1; \
		fi \
	done

# Generate the full PDF
book.pdf: ensure-chapters preface.tex
	@docker run --rm -v "$(PWD)":/book $(DOCKER_IMAGE) pandoc -s \
		--pdf-engine=xelatex \
		--template=tex/pdf.tex \
	  --top-level-division=chapter \
		--toc \
		--toc-depth=1 \
		--metadata-file=$(BOOK_MANIFEST) \
		--variable subparagraph \
	  -f gfm+footnotes \
	  -t latex \
		-o book.pdf \
		--include-before-body preface.tex \
		$(CHAPTERS)

# Clean up generated files
clean:
	@rm -f preface.tex book.pdf book.epub

init:
	@for chapter in $(CHAPTERS); do \
		if [ ! -f $$chapter ]; then \
			echo "# $$(basename $$chapter .md)" > $$chapter; \
			echo "" >> $$chapter; \
			echo "This is the introduction." >> $$chapter; \
			echo "" >> $$chapter; \
			echo "## Section 1" >> $$chapter; \
			echo "" >> $$chapter; \
			echo "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." >> $$chapter; \
			echo "" >> $$chapter; \
			echo "## Section 2" >> $$chapter; \
			echo "" >> $$chapter; \
			echo "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." >> $$chapter; \
			echo "" >> $$chapter; \
			echo "## Wrapping Up" >> $$chapter; \
			echo "" >> $$chapter; \
			echo "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." >> $$chapter; \
			echo "" >> $$chapter; \
		else \
			echo "File $$chapter already exists. Skipping."; \
		fi \
	done
