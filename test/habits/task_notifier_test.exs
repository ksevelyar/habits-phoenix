defmodule Habits.TaskNotifierTest do
  use Habits.DataCase, async: false
  import Habits.Factory
  import Mox

  setup :set_mox_from_context
  setup :verify_on_exit!

  test "notifies matching tasks" do
    System.put_env("TELEGRAM_CHAT_ID", "24")
    System.put_env("TELEGRAM_BOT_TOKEN", "42")
    insert!(:task, cron: "* * * * *", name: "Test task")

    expect(Habits.TelegramApiMock, :request, fn "42", "sendMessage", opts ->
      assert opts[:text] == "• 00:00 Test task"
      assert opts[:chat_id] == "24"

      :ok
    end)

    start_supervised!(Habits.TaskNotifier)
  end

  test "does not notify if the task was already notified today" do
    System.put_env("TELEGRAM_CHAT_ID", "24")
    System.put_env("TELEGRAM_BOT_TOKEN", "42")

    insert!(:task,
      cron: "* * * * *",
      name: "Test task",
      notified_at: DateTime.utc_now()
    )

    start_supervised!(Habits.TaskNotifier)

    expect(Habits.TelegramApiMock, :request, 0, fn _, _, _ -> :ok end)
  end

  test "does not notify inactive tasks" do
    System.put_env("TELEGRAM_CHAT_ID", "24")
    System.put_env("TELEGRAM_BOT_TOKEN", "42")

    insert!(:task,
      cron: "* * * * *",
      name: "Test task",
      active: false
    )

    start_supervised!(Habits.TaskNotifier)

    expect(Habits.TelegramApiMock, :request, 0, fn _, _, _ -> :ok end)
  end
end
