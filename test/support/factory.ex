defmodule Habits.Factory do
  alias Habits.Repo

  def build(:user) do
    %Habits.Users.User{
      email: "email-#{seq()}@domain.tld",
      handle: "handle-#{seq()}",
      password: :crypto.strong_rand_bytes(20)
    }
  end

  def build(:chain) do
    %Habits.Chains.Chain{
      name: "elixir",
      active: true,
      type: :integer,
      description: "pomodoro",
    }
  end

  def build(:metric) do
    %Habits.Metrics.Metric{
      value: 42,
      date: ~D[2024-09-07],
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(facttory_name, attributes \\ [])

  def insert!(:user, attributes) do
    attributes =
      :user
      |> build(attributes)
      |> Map.from_struct()

    {:ok, user} = Habits.Users.create_user(attributes)
    user
  end

  def insert!(factory_name, attributes) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  defp seq do
    System.unique_integer([:monotonic, :positive])
  end
end
