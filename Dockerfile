FROM ruby:3.2.2-alpine

ENV BUNDLER_VERSION=2.4.12

RUN apk add --no-cache bash
RUN gem install bundler -v 2.4.12

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . ./

CMD ["bash"]
