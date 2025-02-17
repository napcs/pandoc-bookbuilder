FROM ubuntu:24.04

# Install dependencies.
# Tex is *huge*.
RUN apt-get update && apt-get install -y  --no-install-recommends \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
#    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-extra-utils \
    texlive-science \
    lmodern \
    ghostscript \
    imagemagick \
    calibre \
    ttf-mscorefonts-installer \
    fonts-dejavu \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /book

# Default command
CMD ["make"]
