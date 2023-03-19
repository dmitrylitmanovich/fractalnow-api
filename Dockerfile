FROM crystallang/crystal

# Install shards
WORKDIR /usr/local
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl git
RUN curl -Lo bin/shards.gz https://github.com/crystal-lang/shards/archive/refs/tags/v0.17.2.tar.gz; gunzip bin/shards.gz; chmod 755 bin/shards

# Add this directory to container as /app
ADD . /app
WORKDIR /app

# Install dependencies
RUN shards install

# Build our app
RUN crystal build --release src/fractalnow-api.cr

# Run the tests
RUN crystal spec

EXPOSE 3000

CMD ./fractalnow-api
