defmodule Fitlog.UsersFixtures do
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "email@domain.tld",
        handle: "handle",
        raw_password: "password"
      })
      |> Fitlog.Users.create_user()

    user
  end
end
