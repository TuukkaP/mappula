defmodule Lukimat.Questionnaires.FormTest do
  use Lukimat.DataCase

  alias Lukimat.Questionnaires

  describe "forms" do
    alias Lukimat.Questionnaires.Form

    @valid_attrs %{name: "Test form", level: "easy", questions: [%{content: "why?", correct_answer: "1", type: "multiple_choice"}]}
    @update_attrs %{level: "some updated level", name: "some updated name"}
    @invalid_attrs %{level: nil, name: nil}

    def form_fixture(attrs \\ %{}) do
      {:ok, form} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questionnaires.create_form()

      form
    end

    test "list_forms/0 returns all forms" do
      form = form_fixture()
      assert Questionnaires.list_forms() |> Questionnaires.with_questions == [form]
    end

    test "get_form!/1 returns the form with given id" do
      form = form_fixture()
      assert Questionnaires.get_form!(form.id) |> Questionnaires.with_questions == form
    end

    test "create_form/1 with valid data creates a form" do
      assert {:ok, %Form{} = form} = Questionnaires.create_form(@valid_attrs)
      assert form.level == "easy"
      assert form.name == "Test form"
    end

    test "create_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_form(@invalid_attrs)
    end

    test "update_form/2 with valid data updates the form" do
      form = form_fixture()
      assert {:ok, form} = Questionnaires.update_form(form, @update_attrs)
      assert %Form{} = form
      assert form.level == "some updated level"
      assert form.name == "some updated name"
    end

    test "update_form/2 with invalid data returns error changeset" do
      form = form_fixture()
      assert {:error, %Ecto.Changeset{}} = Questionnaires.update_form(form, @invalid_attrs)
      assert form == Questionnaires.get_form!(form.id) |> Questionnaires.with_questions
    end

    test "delete_form/1 deletes the form" do
      form = form_fixture()
      assert {:ok, %Form{}} = Questionnaires.delete_form(form)
      assert_raise Ecto.NoResultsError, fn -> Questionnaires.get_form!(form.id) end
    end

    test "change_form/1 returns a form changeset" do
      form = form_fixture()
      assert %Ecto.Changeset{} = Questionnaires.change_form(form)
    end
  end
end
