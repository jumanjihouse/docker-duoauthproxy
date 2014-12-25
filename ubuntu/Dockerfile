FROM ubuntu:latest

ONBUILD RUN apt-get update; \
            apt-get -q -y dist-upgrade; \
            apt-get install -q -y python; \
            apt-get clean
RUN useradd duo
