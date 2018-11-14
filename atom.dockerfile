FROM ruby:2.3.7-alpine
MAINTAINER Yohann Leon <yohann@leon.re>

WORKDIR /usr/atom

RUN apk add --update tzdata curl wget bash ruby ruby-bundler nodejs ruby-dev g++ musl-dev make imagemagick imagemagick-dev
RUN gem install bundler smashing json
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo "Europe/Paris" > /etc/timezone

ADD . /usr/atom
RUN bundle

ENV PORT 3030
EXPOSE $PORT

ENTRYPOINT ["smashing"]
CMD ["start", "-p", "$PORT"]
