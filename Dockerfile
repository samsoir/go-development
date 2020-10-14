FROM alpine:3.7
RUN apk update
RUN apk add git
RUN apk add bash

RUN git clone https://github.com/kward/shunit2.git
RUN cp shunit2/shunit2 /usr/local/bin/shunit2
