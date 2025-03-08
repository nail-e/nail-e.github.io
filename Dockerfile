FROM ruby:3.0.2

# Set working directory
WORKDIR /app

# Install dependencies for Jekyll
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libffi-dev \
  libpq-dev \
  nodejs \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Install Bundler and Jekyll globally
RUN gem install bundler jekyll

# Copy the Gemfile and Gemfile.lock to install dependencies first
COPY Gemfile Gemfile.lock /app/

# Install the required gems
RUN bundle install

# Copy the rest of the application
COPY . /app

# Expose ports: 4000 for Jekyll, 35729 for LiveReload (browser sync)
EXPOSE 4000 35729

# Run Jekyll with LiveReload enabled
CMD ["bundle", "exec", "jekyll", "serve", "--host=0.0.0.0", "--livereload", "--force_polling"]

