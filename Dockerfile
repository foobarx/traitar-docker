############################################################
# Dockerfile to run Traitar - the microbial trait analyzer 
# Based on Ubuntu Image
############################################################

# Set the base image to use to Ubuntu
FROM ubuntu:trusty 

ENV http_proxy http://rzproxy.helmholtz-hzi.de:3128
ENV https_proxy http://rzproxy.helmholtz-hzi.de:3128

RUN apt-get update
MAINTAINER Aaron Weimann (weimann@hhu.de)
RUN apt-get -y install python-scipy python-matplotlib python-pip python-pandas
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse ">> /etc/apt/sources.list 
RUN apt-get -y update
RUN apt-get -y install hmmer prodigal
RUN apt-get -y install wget 
RUN apt-get -y install git
RUN mkdir /home/traitar
RUN wget -O /home/traitar/Pfam-A.hmm.gz http://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam27.0/Pfam-A.hmm.gz
RUN gunzip /home/traitar/Pfam-A.hmm.gz 
RUN apt-get -y install parallel 
ENV SHELL /bin/bash
WORKDIR  /home/traitar
ADD https://www.random.org/strings/?num=16&len=16&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new uuid
RUN git clone https://github.com/foobarx/traitar
WORKDIR  /home/traitar/traitar
RUN python setup.py sdist
RUN pip install traitar  --find-links file:///home/traitar/traitar/dist
RUN traitar pfam --local /home/traitar
ENTRYPOINT /home/traitar/traitar/bin/traitar_from_archive
