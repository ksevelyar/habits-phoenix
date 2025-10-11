defmodule Habits.TaskNotifier do
  use GenServer
  import Ecto.Query
  alias Habits.Repo
  alias Habits.Tasks.Task
  require Logger

  @poll_interval :timer.seconds(1)

  def start_link(_opts),
    do: GenServer.start_link(__MODULE__, %{last_summary_date: nil}, name: __MODULE__)

  @impl true
  def init(state) do
    new_state = notify(state)
    schedule_notify()

    {:ok, new_state}
  end

  @impl true
  def handle_info(:notify, state) do
    new_state = notify(state)
    schedule_notify()

    {:noreply, new_state}
  end

  defp maybe_send_daily_summary(%{last_summary_date: last_date} = state) do
    now = DateTime.now!("Europe/Moscow")
    today = DateTime.to_date(now)
    {hour, min, _sec} = Time.to_erl(DateTime.to_time(now))
    daily_summary_time = {8, 0}

    if {hour, min} == daily_summary_time and last_date != today do
      send_daily_summary()
      %{state | last_summary_date: today}
    else
      state
    end
  end

  def send_daily_summary do
    {:ok, now_moscow} = DateTime.now("Europe/Moscow")
    today = DateTime.to_date(now_moscow)
    start_of_today = DateTime.new!(today, ~T[00:00:00], now_moscow.time_zone)

    tasks_with_next_time =
      Repo.all(from t in Task, where: t.active == true)
      |> Enum.map(fn task ->
        with {:ok, cron} <- Crontab.CronExpression.Parser.parse(task.cron),
             {:ok, next_date} <- Crontab.Scheduler.get_next_run_date(cron, start_of_today) do
          next_dt_moscow = DateTime.shift_zone!(next_date, "Europe/Moscow")
          {task, next_dt_moscow}
        else
          _ -> {task, nil}
        end
      end)

    tasks =
      tasks_with_next_time
      |> Enum.filter(fn {_task, next_time} ->
        match?(%DateTime{}, next_time) and DateTime.to_date(next_time) == today
      end)
      |> Enum.sort_by(fn {_task, next_dt} -> next_dt end)

    if tasks != [] do
      summary =
        tasks
        |> Enum.map(fn
          {t, %DateTime{} = dt} ->
            task_label(t, dt)
        end)
        |> Enum.join("\n")

      token = System.get_env("TELEGRAM_BOT_TOKEN")
      chat_id = System.get_env("TELEGRAM_CHAT_ID")

      today_label = Calendar.strftime(today, "%d.%m.%y")
      Habits.TelegramApi.request(token, "sendMessage",
        chat_id: chat_id,
        text: "📋 #{today_label}\n\n" <> summary
      )
    end
  end

  defp task_label(task, dt) do
    next_time = Calendar.strftime(dt, "%H:%M")

    "• #{next_time} #{task.name}"
  end

  def notify(state) do
    now = DateTime.now!("Europe/Moscow")
    today = DateTime.to_date(now)

    query =
      from t in Task,
        where: t.active == true,
        where: is_nil(t.notified_at) or fragment("date(?) != ?", t.notified_at, ^today)

    query
    |> Repo.all()
    |> Enum.each(&maybe_notify/1)

    maybe_send_daily_summary(state)
  end

  def maybe_notify(task) do
    case Crontab.CronExpression.Parser.parse(task.cron) do
      {:ok, cron} ->
        {:ok, now} = DateTime.now("Europe/Moscow")

        if Crontab.DateChecker.matches_date?(cron, now) do
          token = System.get_env("TELEGRAM_BOT_TOKEN")
          chat_id = System.get_env("TELEGRAM_CHAT_ID")

          {:ok, now_moscow} = DateTime.now("Europe/Moscow")
          today = DateTime.to_date(now_moscow)
          start_of_today = DateTime.new!(today, ~T[00:00:00], now_moscow.time_zone)

          {:ok, next_date} = Crontab.Scheduler.get_next_run_date(cron, start_of_today)

          Habits.TelegramApi.request(token, "sendMessage",
            chat_id: chat_id,
            text: task_label(task, next_date)
          )

          task
          |> Ecto.Changeset.change(notified_at: DateTime.utc_now())
          |> Repo.update()
        end

      {:error, reason} ->
        Logger.warning("Invalid cron #{inspect(task.cron)}: #{inspect(reason)}")
    end
  end

  defp schedule_notify do
    Process.send_after(self(), :notify, @poll_interval)
  end
end
