FROM ruby:3.3-bookworm

WORKDIR /app

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT=development:test \
    BUNDLE_PATH=/usr/local/bundle

COPY Gemfile Gemfile.lock* ./
RUN bundle install

COPY . .

EXPOSE 8080
CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -p ${PORT:-8080}"]
