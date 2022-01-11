defmodule Fitlog.UsersTest do
  use Fitlog.DataCase

  alias Fitlog.Users

  describe "users" do
    alias Fitlog.Users.User

    import Fitlog.UsersFixtures

    @invalid_attrs %{email: "babah", handle: "@sobaken"}

    test "list/0 returns all users" do
      user = user_fixture()
      assert Users.list() == [user]
    end

    test "get/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get!(user.id) == user
    end

    test "upsert/1 with valid data creates a user" do
      valid_attrs = %{email: "email@domain.tld", handle: "ksevelyar", avatar_url: "babah"}

      assert {:ok, %User{} = user} = Users.upsert(valid_attrs)
      assert user.email == "email@domain.tld"
      assert user.handle == "ksevelyar"
      assert user.avatar_url == "babah"
    end

    test "upsert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.upsert(@invalid_attrs)
    end

    test "update/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "ksevelyar@domain.tld",
        handle: "babaher"
      }

      assert {:ok, %User{} = user} = Users.update(user, update_attrs)
      assert user.email == "ksevelyar@domain.tld"
      assert user.handle == "babaher"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update(user, @invalid_attrs)
      assert user == Users.get!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change(user)
    end
  end
end
