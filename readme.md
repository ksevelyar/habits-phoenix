# Fitlog [![ci](https://github.com/ksevelyar/fitlog-phoenix/actions/workflows/ci.yml/badge.svg)](https://github.com/ksevelyar/fitlog-phoenix/actions/workflows/ci.yml)

* JSON API with CORS
* JWT via https only cookie. The scheme requires the same top level domain for both front-end and back-end, which is small price for making JWT not readable by JS.
* Bodyguard for authorization
* Ueberauth for authentication
* configuration via ENV variables

## Boilerplate

```
mix archive.install hex phx_new
mix phx.new fitlog-phoenix --app fitlog --no-assets --no-html --no-dashboard --no-gettext --no-live --no-mailer
```

## Setup

`mix deps.get`
`mix ecto.setup`

`mix phx.server` or inside IEx with `iex -S mix phx.server`

`curlie localhost:4000`

## Test

Run tests with `iex -S mix test --trace` to use `require IEx; IEx.pry`
