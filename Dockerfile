FROM ruby:2.7.3-buster

ENV RAILS_ENV=production

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn
WORKDIR /app
COPY ./src /app
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh", "/start.sh"]
