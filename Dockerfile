FROM alpine:3.7
RUN apk update
RUN apk add git

RUN git clone https://github.com/kward/shunit2.git
