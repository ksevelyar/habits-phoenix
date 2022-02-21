defmodule Fitlog.UsersFixtures do
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "email@domain.tld",
        handle: "handle",
        avatar_url: "https://avatars.githubusercontent.com/u/725959?v=4",
        github_id: 42
      })
      |> Fitlog.Users.upsert()

    user
  end
end
