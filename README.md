# Simple OAuth Ruby Client
A simple OAuth client to comunicate with Resource Servers and Authorization Servers

## Local development
There is a Dockerfile that is ready to be used as a development platform.

### Build image
Build your image to start your dev env.

```shell
docker build . -t simple-oauth-ruby-client
```

### Run
To run your built image for testing, manually calling servers, etc.

```shell
docker run -it --rm \
  --name simple-oauth-ruby-client-container \
  --mount type=bind,source="$(pwd)",target=/app \
  simple-oauth-ruby-client
```

Command above will leave you inside the Docker container, where you could run, for example:

```shell
bundle exec rspec

# or

ruby simple_oauth_client.rb
```
