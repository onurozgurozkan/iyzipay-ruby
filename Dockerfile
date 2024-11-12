FROM ruby:2.7

COPY . /usr/src

WORKDIR /usr/src

RUN gem update --system 3.3.20
RUN gem install bundler:2.4.22
RUN bundle install