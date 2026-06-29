FROM nginx:alpine-slim

ARG VERSION=0.0.0-alpha1
ARG DEPLOY_MODE=prod
ENV VERSION=${VERSION}
ENV DEPLOY_MODE=${DEPLOY_MODE}

# ALPINE: timezone and locale
RUN apk update
RUN apk add --no-cache tzdata
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN rm -r /usr/share/zoneinfo/Africa && \
    rm -r /usr/share/zoneinfo/Antarctica && \
    rm -r /usr/share/zoneinfo/Arctic && \
    rm -r /usr/share/zoneinfo/America && \
    rm -r /usr/share/zoneinfo/Atlantic && \
    rm -r /usr/share/zoneinfo/Australia && \
    rm -r /usr/share/zoneinfo/Europe  && \
    rm -r /usr/share/zoneinfo/Indian && \
    rm -r /usr/share/zoneinfo/Mexico && \
    rm -r /usr/share/zoneinfo/Pacific && \
    rm -r /usr/share/zoneinfo/Chile && \
    rm -r /usr/share/zoneinfo/Canada \
    rm -vrf /var/cache/apk/*
RUN echo "Asia/Seoul" > /etc/timezone
ENV TZ Asia/Seoul
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /usr/share/nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY ./dist /usr/share/nginx/html

WORKDIR /usr/share/nginx
COPY ./.env.${DEPLOY_MODE} .env.${DEPLOY_MODE}
RUN sed -n "s/^VITE_VERSION = '\(.*\)'$/\1/p" .env.${DEPLOY_MODE} > html/VERSION.txt
EXPOSE 80
