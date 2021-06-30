# Fitlog Phoenix API

## Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Reports

```
mix phx.routes
```

```
report_path  GET     /reports      FitlogWeb.ReportController :index
report_path  GET     /reports/:id  FitlogWeb.ReportController :show
report_path  POST    /reports      FitlogWeb.ReportController :create
report_path  PATCH   /reports/:id  FitlogWeb.ReportController :update
report_path  DELETE  /reports/:id  FitlogWeb.ReportController :delete
```

## Test

`mix test`
