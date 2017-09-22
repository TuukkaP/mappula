defmodule Lukimat.QuestionnairesTest do
  use Lukimat.DataCase

  alias Lukimat.Questionnaires

  describe "questions" do
    alias Lukimat.Questionnaires.Question

    @valid_attrs %{choices: %{}, content: "some content", correct_answer: 42, level: "some level"}
    @update_attrs %{choices: %{}, content: "some updated content", correct_answer: 43, level: "some updated level"}
    @invalid_attrs %{choices: nil, content: nil, correct_answer: nil, level: nil}

    def question_fixture(attrs \\ %{}) do
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
      assert {:ok, %Question{} = question} = Questionnaires.create_question(@valid_attrs)
      assert question.choices == %{}
      assert question.content == "some content"
      assert question.correct_answer == 42
      assert question.level == "some level"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, question} = Questionnaires.update_question(question, @update_attrs)
      assert %Question{} = question
      assert question.choices == %{}
      assert question.content == "some updated content"
      assert question.correct_answer == 43
      assert question.level == "some updated level"
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

  describe "answers" do
    alias Lukimat.Questionnaires.Answer

    @valid_attrs %{answer: 42, is_correct: true}
    @update_attrs %{answer: 43, is_correct: false}
    @invalid_attrs %{answer: nil, is_correct: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questionnaires.create_answer()

      answer
    end

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Questionnaires.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Questionnaires.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Questionnaires.create_answer(@valid_attrs)
      assert answer.answer == 42
      assert answer.is_correct == true
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, answer} = Questionnaires.update_answer(answer, @update_attrs)
      assert %Answer{} = answer
      assert answer.answer == 43
      assert answer.is_correct == false
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Questionnaires.update_answer(answer, @invalid_attrs)
      assert answer == Questionnaires.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Questionnaires.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Questionnaires.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Questionnaires.change_answer(answer)
    end
  end

  describe "forms" do
    alias Lukimat.Questionnaires.Form

    @valid_attrs %{level: "some level", name: "some name"}
    @update_attrs %{level: "some updated level", name: "some updated name"}
    @invalid_attrs %{level: nil, name: nil}

    def form_fixture(attrs \\ %{}) do
      {:ok, form} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questionnaire.create_form()

      form
    end

    test "list_forms/0 returns all forms" do
      form = form_fixture()
      assert Questionnaire.list_forms() == [form]
    end

    test "get_form!/1 returns the form with given id" do
      form = form_fixture()
      assert Questionnaire.get_form!(form.id) == form
    end

    test "create_form/1 with valid data creates a form" do
      assert {:ok, %Form{} = form} = Questionnaire.create_form(@valid_attrs)
      assert form.level == "some level"
      assert form.name == "some name"
    end

    test "create_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaire.create_form(@invalid_attrs)
    end

    test "update_form/2 with valid data updates the form" do
      form = form_fixture()
      assert {:ok, form} = Questionnaire.update_form(form, @update_attrs)
      assert %Form{} = form
      assert form.level == "some updated level"
      assert form.name == "some updated name"
    end

    test "update_form/2 with invalid data returns error changeset" do
      form = form_fixture()
      assert {:error, %Ecto.Changeset{}} = Questionnaire.update_form(form, @invalid_attrs)
      assert form == Questionnaire.get_form!(form.id)
    end

    test "delete_form/1 deletes the form" do
      form = form_fixture()
      assert {:ok, %Form{}} = Questionnaire.delete_form(form)
      assert_raise Ecto.NoResultsError, fn -> Questionnaire.get_form!(form.id) end
    end

    test "change_form/1 returns a form changeset" do
      form = form_fixture()
      assert %Ecto.Changeset{} = Questionnaire.change_form(form)
    end
  end
end
