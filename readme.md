# Habits

## Setup

* `direnv allow`
* `mix deps.get`
* `mix ecto.setup`

## Run

`mix phx.server` or inside IEx with `iex -S mix phx.server`

`curlie localhost:4000`

## Test

Run tests with `iex -S mix test --trace` to use `require IEx; IEx.pry`

Wipe test db with `MIX_ENV=test mix ecto.reset`
