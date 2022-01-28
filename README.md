# Fitlog [![ci](https://github.com/ksevelyar/fitlog-phoenix/actions/workflows/ci.yml/badge.svg)](https://github.com/ksevelyar/fitlog-phoenix/actions/workflows/ci.yml)

## Auth

* upsert user via GitHub's oauth2
* sign jwt token in https only cookie

## Setup

`.env`

```
GITHUB_CLIENT_ID=id
GITHUB_CLIENT_SECRET=secret
FRONT=http://localhost:8080
```

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
