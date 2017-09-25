defmodule Lukimat.UserTest do
  use Lukimat.DataCase
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Lukimat.Accounts

  describe "users" do
    alias Lukimat.Accounts.User

    @valid_attrs %{class: "some class", email: "test@example.org", password: "password", password_confirmation: "password", first_name: "some first_name", language: "some language", last_name: "some last_name", role: "some role"}
    @update_attrs %{class: "some updated class", email: "new_test@example.org", encrypted_password: "some updated encrypted_password", first_name: "some updated first_name", language: "some updated language", last_name: "some updated last_name", role: "some updated role"}
    @invalid_attrs %{class: nil, email: nil, encrypted_password: nil, first_name: nil, language: nil, last_name: nil, role: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      %{user | password: nil, password_confirmation: nil}
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.class == "some class"
      assert user.email == "test@example.org"
      assert checkpw(user.password, user.encrypted_password)
      assert user.first_name == "some first_name"
      assert user.language == "some language"
      assert user.last_name == "some last_name"
      assert user.role == "some role"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.class == "some updated class"
      assert user.email == "new_test@example.org"
      assert checkpw("password", user.encrypted_password)
      assert user.first_name == "some updated first_name"
      assert user.language == "some updated language"
      assert user.last_name == "some updated last_name"
      assert user.role == "some updated role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
