defmodule Habits.Users do
  import Ecto.Query, warn: false
  alias Habits.Repo

  alias Habits.Users.{User, Token}

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.registration_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  def get_by_email_and_password(email, password) do
    user = Repo.get_by(User, email: email)

    if valid_password?(user, password), do: user
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Habits.Users.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  def generate_session_token(user) do
    {token, user_token} = Token.build_session_token(user)

    Repo.insert!(user_token)
    token
  end

  def delete_session_token(token) do
    Repo.delete_all(Token.token_and_context_query(token, "session"))
    :ok
  end

  def get_by_session_token(token) do
    {:ok, query} = Token.verify_session_token_query(token)
    Repo.one(query)
  end
end
