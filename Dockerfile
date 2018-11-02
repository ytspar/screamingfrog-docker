# modified ubuntu https://github.com/phusion/baseimage-docker
FROM phusion/baseimage
CMD ["/sbin/my_init"]

ENV SF_MEMORY "2g"
ARG SF_VERSION="10.3"

RUN apt-get update && apt-get install -y \
    wget \
    xdg-utils \
    zenity \
    ttf-mscorefonts-installer \
    fonts-wqy-zenhei \
    libgconf-2-4

RUN wget --no-verbose https://download.screamingfrog.co.uk/products/seo-spider/screamingfrogseospider_${SF_VERSION}_all.deb && \
    dpkg -i /screamingfrogseospider_${SF_VERSION}_all.deb && \
    apt-get install -f -y

COPY spider.config /root/.ScreamingFrogSEOSpider/spider.config
COPY licence.txt /root/.ScreamingFrogSEOSpider/licence.txt

RUN mkdir -p /home/sf-entry
COPY docker-entrypoint.sh /sf-entry/docker-entrypoint.sh

ENTRYPOINT ["/sf-entry/docker-entrypoint.sh"]
CMD ["--help"]
