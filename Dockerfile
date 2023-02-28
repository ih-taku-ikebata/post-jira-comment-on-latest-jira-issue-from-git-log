FROM ruby:2.7.4-alpine3.14

ENV JIRA_RUBY_VERSION 2.3.0

COPY entrypoint.sh /entrypoint.sh
COPY script.rb /script.rb

RUN apk --no-cache add git \
    && gem install jira-ruby -v $JIRA_RUBY_VERSION

ENTRYPOINT ["/entrypoint.sh"]
