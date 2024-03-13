FROM ruby:3.3.0-bullseye

ENV RAILS_ROOT /app

RUN mkdir -p $RAILS_ROOT

RUN gem install bundler

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]