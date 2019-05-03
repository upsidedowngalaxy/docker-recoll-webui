FROM ubuntu:18.04
MAINTAINER gorgia <gorgia@fastwebnet.it>

RUN adduser --disabled-password docker

VOLUME /data

EXPOSE 8080


#this should be picked up by recollindex
ENV RECOLL_CONFDIR /home/.recoll
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && \
	apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages apt-utils && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages software-properties-common

RUN add-apt-repository ppa:recoll-backports/recoll-1.15-on

RUN apt-get update && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages apt-transport-https && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages python3-pip python3-dev python-cherrypy3 && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages recoll python3 git wv poppler-utils && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages aspell-it && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages aspell-ar && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages aspell-en && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages unrar unzip xsltproc unrtf untex libimage-exiftool-perl antiword pstotext tesseract-ocr && \
    apt-get clean

RUN git clone https://@opensourceprojects.eu/git/p/recollwebui/code /home/docker/recoll-webui/
RUN chmod 777 -R /home/docker/recoll-webui/

COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/startrecoll.sh && chmod +x /usr/local/bin//bgindex.sh
COPY recoll.conf /home/.recoll/

CMD ["/usr/local/bin/startrecoll.sh"]