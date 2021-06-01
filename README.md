# Fitlog

## Reports

```
report_path  GET     /api/reports      FitlogWeb.ReportController :index
report_path  GET     /api/reports/:id  FitlogWeb.ReportController :show
report_path  POST    /api/reports      FitlogWeb.ReportController :create
report_path  PATCH   /api/reports/:id  FitlogWeb.ReportController :update
report_path  DELETE  /api/reports/:id  FitlogWeb.ReportController :delete
```

## Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
