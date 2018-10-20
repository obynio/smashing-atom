FROM ruby:2.3.7-alpine
MAINTAINER Yohann Leon <yohann@leon.re>

WORKDIR /usr/cicada

RUN apk add --update tzdata curl wget bash ruby ruby-bundler nodejs ruby-dev g++ musl-dev make imagemagick imagemagick-dev
RUN gem install bundler smashing json

ADD . /usr/cicada
RUN bundle

ENV PORT 3030
EXPOSE $PORT

ENTRYPOINT ["smashing"]
CMD ["start", "-p", "$PORT"]
