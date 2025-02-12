defmodule Habits.TelegramApi do
  @callback request(String.t(), String.t(), keyword()) :: any()

  def request(token, method, opts), do: impl().request(token, method, opts)

  defp impl, do: Application.get_env(:habits, :telegram_api, Telegram.Api)
end
