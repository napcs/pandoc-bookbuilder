# Pandoc Book Template

Turn a bunch of Markdown files into PDF and ePub files.

Pandoc is a great tool for converting text, but to make PDfs you basically need TeX. And setting that up is awful.

This project packages up Tex, Pandoc, and other tools into a Docker container and gives you a book template and a Makefile to build your book.

## Create your Book

Fork and clone this repository. It's your starter template.

Fill in the `book.yaml` file with your details. Add your chapter filenames in. They don't need to exist; this can generate files for you.

```yaml
title: "My Book"
subtitle: "My Subtitle"
author: "Some Author"
version: "1.0"
cover-image: "images/cover.jpg"
lang: "en"
date: "2025"
publisher: "Open Source Press"
editor: "Some Editor"
chapters:
  - "get_started.md"
  - "doing_more_stuff.md"
  - "even_more_stuff.md"
```

List the chapters in the order you want them to appear in the book. And don't name them "Chapter 1". You'll eventually have to reorder your book chapters, and it'll be terrible. So just name things what they are and keep them ordered here.

Generate chapter files:

```bash
$ make init
```

This makes a Markdown file from your chapter list, skipping any existing file.

Build the Docker image:

```bash
$ make build-image
```

This takes a while. There's a lot to build.

While that's building, edit the Markdown files, includuing `preface.md` with your content.

## Building books

Make a PDF

```bash
$ make pdf
```

Make an epub

```bash
$ make epub
```

## Front and Back Matter

In traditional books, things like acknowledgements, a preface, and a foreword go in "front matter". These sections don't get chapter numbers and aren't typically given normal page numbers.

`preface.md` is included in the build as front matter for PDFs.

Appendices, advertisements, and indexes are "back matter."

`appendix.md` is included in the build as back matter for PDFs.

Pandoc requires these files to be added separately as raw TeX files, so you will find tasks in the Makefile for both. If you want to add more chapters to front or back matter you will need to adjust the Makefile rules.

## Customizing Your Book

You'll find the book template for PDFs in the `tex/` folder. What's there is based off of Pandoc's built-in ebook template and modified.

Epubs use the normal Pandoc template that's built-in. Right now there's no tex templating for that. That'll come later.

The extended fonts are commented out in the Dockerfile because it adds a ton of files. The image is already 2GB in size. Fonts make it almost 5GB.

## Known issues

Since this runs in containers, there may be a file system synchronization issue on some systems where the preface and appendix fail with the error:

```
pandoc: preface.tex: withFile: does not exist (No such file or directory)
```

Run the build again and it will work.

## Changes

### 2025-02-26
- Added `appendix.md` to the repository.
- Support for backmatter properly implemented in `tex/pdf.tex`.
- Improved body text and heading spacing in `tex/pdf.tex`.
- PDF Code blocks are now shaded in `tex/pdf.tex`.
- Removed unused `tex/frontmatter.tex` file.
