# Default Ruby version for this project.
ARG RUBY_VERSION=3.2.2

# Base image
FROM ruby:$RUBY_VERSION-alpine AS base

# Set environment variables for the username,
# app directory, and the language.
ENV USER oauth_ruby_client
ENV APP_DIR /app

# Set env variables for dev
ENV BUNDLER_VERSION 2.4.12
ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_JOBS 4
ENV BUNDLE_RETRY 3
ENV RAILS_ENV development
ENV RACK_ENV development
ENV PATH=$APP_DIR/bin:$PATH
ENV LANG C.UTF-8

# Add timezone libraries,
# and git for development.
RUN apk add --no-cache --update \
      tzdata \
      git \
    && rm -rf /var/cache/apk/*

# Start building a new image called "dependencies"
# from the "base" image.
FROM base AS dependencies

# Add libraries required for installing gems.
RUN apk add --no-cache  --update \
      build-base \
    && rm -rf /var/cache/apk/*

# Copy the Gemfile and Gemfile.lock
# files to the current directory.
COPY Gemfile Gemfile.lock ./

# Install bundler with specified version.
RUN gem install bundler -v $BUNDLER_VERSION

# "frozen" option means that the exact versions of gems
# specified in the Gemfile.lock file will be used,
# and any updates to those gems will be ignored.
#
# Install gems with ENV options from above,
# remove unnecessary files from gems.
RUN bundle config --global frozen 1 && \
    bundle install && \
    rm -rf $BUNDLE_PATH/cache/*.gem && \
    rm -rf $BUNDLE_PATH/ruby/*/cache && \
    find $BUNDLE_PATH/gems/ -name "*.c" -delete && \
    find $BUNDLE_PATH/gems/ -name "*.o" -delete

# Start building a new image from the "base" image.
FROM base

# Copy entrypoint, make it executable.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Add new user in the system.
RUN adduser -D $USER

# Create directory for rails application,
# set user as the owner.
RUN mkdir -p $APP_DIR && \
    chown $USER $APP_DIR

# Set the working directory to the app directory.
WORKDIR $APP_DIR

# Switch from root to specified user.
USER $USER

# Copy the bundle directory from the "dependencies"
# image and copy all files to the current directory,
# setting the ownership to the specified user.
COPY --from=dependencies $BUNDLE_PATH $BUNDLE_PATH
COPY --chown=$USER . ./

# Expose port 3000 for the application.
# EXPOSE 3000
