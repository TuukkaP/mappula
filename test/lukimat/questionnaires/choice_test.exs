defmodule Lukimat.Questionnaires.ChoiceTest do
  use Lukimat.DataCase
  require IEx

  alias Lukimat.Questionnaires

  describe "choices" do
    alias Lukimat.Questionnaires.Question
    alias Lukimat.Questionnaires.Choice

    @valid_attrs %{content: "some content", url: "some url"}
    #@valid_attrs %{content: "some content", url: "some url"}
    @update_attrs %{content: "some updated content", url: "some updated url"}
    @invalid_attrs %{content: nil, url: nil}

    setup do
      {:ok, form} = Questionnaires.create_form(%{name: "Test form", level: "easy"})
      {:ok, question} = Questionnaires.create_question(
        %{content: "some content", correct_answer: "42", type: "multiple_choice", form_id: form.id}
      )
      {:ok, question: question}
    end

    def choice_fixture(attrs \\ %{}) do
      question = Question |> Ecto.Query.first |> Lukimat.Repo.one
      attrs = Map.merge(attrs, %{question_id: question.id})

      {:ok, choice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questionnaires.create_choice()

      choice
    end

    test "list_choices/0 returns all choices" do
      choice = choice_fixture()
      assert Questionnaires.list_choices() == [choice]
    end

    test "get_choice!/1 returns the choice with given id" do
      choice = choice_fixture()
      assert Questionnaires.get_choice!(choice.id) == choice
    end

    test "create_choice/1 with valid data creates a choice", ctx do
      attrs = Map.merge(@valid_attrs, %{question_id: ctx[:question].id})
      assert {:ok, %Choice{} = choice} = Questionnaires.create_choice(attrs)
      assert choice.content == "some content"
      assert choice.url == "some url"
    end

    test "create_choice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_choice(@invalid_attrs)
    end

    test "update_choice/2 with valid data updates the choice" do
      choice = choice_fixture()
      assert {:ok, choice} = Questionnaires.update_choice(choice, @update_attrs)
      assert %Choice{} = choice
      assert choice.content == "some updated content"
      assert choice.url == "some updated url"
    end

    test "update_choice/2 with invalid data returns error changeset" do
      choice = choice_fixture()
      assert {:error, %Ecto.Changeset{}} = Questionnaires.update_choice(choice, @invalid_attrs)
      assert choice == Questionnaires.get_choice!(choice.id)
    end

    test "delete_choice/1 deletes the choice" do
      choice = choice_fixture()
      assert {:ok, %Choice{}} = Questionnaires.delete_choice(choice)
      assert_raise Ecto.NoResultsError, fn -> Questionnaires.get_choice!(choice.id) end
    end

    test "change_choice/1 returns a choice changeset" do
      choice = choice_fixture()
      assert %Ecto.Changeset{} = Questionnaires.change_choice(choice)
    end
  end
end
