FROM ruby:2.5.1
ARG RAILS_ENV
ARG RAILS_MASTER_KEY
ENV APP_ROOT /app
ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}
RUN apt-get update -qq && apt-get install -y build-essential nodejs unzip
RUN CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable
WORKDIR $APP_ROOT
ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

RUN \
  bundle install && \
  rm -rf ~/.gem

ADD . $APP_ROOT
RUN bundle exec rails assets:precompile
EXPOSE  3000
CMD ["rails", "server", "-b", "0.0.0.0"]
