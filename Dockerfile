FROM node:10.15.3-slim

RUN mkdir /out

# libx11, etc: Chromium dependencies
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y \
    libx11-6 libxcomposite1 libx11-xcb1 libx11-dev libgtk-3-0 libnss3 libxss1 libsoundio1 \
  && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install Noto Color Emoji font so our Chromium can render color emoji like a typical end-user machine.
# This Debian package was originally downloaded from
RUN curl --fail -s -S https://cdn-aws.deb.debian.org/debian/pool/main/f/fonts-noto-color-emoji/fonts-noto-color-emoji_0~20180810-1_all.deb \
      -o /tmp/fonts-noto-color-emoji.deb && \
      dpkg -i /tmp/fonts-noto-color-emoji.deb && \
      rm /tmp/fonts-noto-color-emoji.deb

# Install puppeteer; which auto-downloads Chromium
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
RUN cd /app && npm ci

# Copy rest of example code
COPY . /app
