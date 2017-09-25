defmodule Lukimat.Questionnaires.QuestionTest do
  use Lukimat.DataCase
  require IEx

  alias Lukimat.Questionnaires

  describe "questions" do
    alias Lukimat.Questionnaires.Question
    alias Lukimat.Questionnaires.Form

    @valid_attrs %{content: "some content", correct_answer: "42", type: "multiple_choice"}
    @update_attrs %{content: "some updated content", correct_answer: "43", level: "some updated level"}
    @invalid_attrs %{choices: nil, content: nil, correct_answer: nil, level: nil}

    setup do
      {:ok, form} = Questionnaires.create_form(%{name: "Test form", level: "easy"})
      {:ok, form: form}
    end

    def question_fixture(attrs \\ %{}) do
      form = Form |> Ecto.Query.first |> Lukimat.Repo.one
      attrs = Map.merge(attrs, %{form_id: form.id})

      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questionnaires.create_question()
      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questionnaires.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questionnaires.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      question = question_fixture()
      assert question.content == "some content"
      assert question.correct_answer == "42"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, question} = Questionnaires.update_question(question, @update_attrs)
      assert %Question{} = question
      assert question.content == "some updated content"
      assert question.correct_answer == "43"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questionnaires.update_question(question, @invalid_attrs)
      assert question == Questionnaires.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questionnaires.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questionnaires.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questionnaires.change_question(question)
    end
  end
end
