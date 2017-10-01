defmodule Lukimat.Questionnaires.AnswerTest do
  use Lukimat.DataCase
  require IEx
  alias Lukimat.Questionnaires
  alias Lukimat.Accounts

  describe "answers" do
    alias Lukimat.Questionnaires.Answer

    @form_attrs %{name: "Test form", level: "easy", questions: [%{content: "why?", correct_answer: "1", type: "text"}]}
    @user_attrs %{class: "some class", email: "test@example.org", password: "password", password_confirmation: "password", first_name: "some first_name", language: "some language", last_name: "some last_name", role: "some role"}
    @valid_attrs %{answer: 1}
    @update_attrs %{answer: 43}
    @invalid_attrs %{answer: nil}

    setup do
      {:ok, form} = Questionnaires.create_form(@form_attrs)
      {:ok, user} = Accounts.create_user(@user_attrs)
      question = form.questions |> List.first
      params = Enum.into(@valid_attrs, %{question_id: question.id})

      {:ok, form_answer} =
        %{
          form_id: form.id, user_id: user.id,
          answers: [params]
        } |> Questionnaires.create_form_answer

      {:ok, answer: (form_answer.answers |> List.first), params: params}
    end

    test "list_answers/0 returns all answers", %{answer: answer} do
      assert Questionnaires.list_answers() |> Questionnaires.with_question_and_choices == [answer]
    end

    test "get_answer!/1 returns the answer with given id", %{answer: answer} do
      assert Questionnaires.get_answer!(answer.id) |> Questionnaires.with_question_and_choices == answer
    end

    test "create_answer/1 with valid data creates a answer", %{params: params} do
      assert {:ok, %Answer{} = answer} = Questionnaires.create_answer(params)
      assert answer.answer == 1
      assert answer.is_correct == true
    end

    test "create_answer/1 with invalid data returns error changeset", %{params: params} do
      attrs = Enum.into(@invalid_attrs, params)
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_answer(attrs)
    end

    test "update_answer/2 with valid data updates the answer", %{answer: answer} do
      assert {:ok, answer} = Questionnaires.update_answer(answer, @update_attrs)
      assert %Answer{} = answer
      assert answer.answer == 43
      assert answer.is_correct == false
    end

    test "update_answer/2 with invalid data returns error changeset", %{answer: answer} do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.update_answer(answer, @invalid_attrs)
      assert answer == Questionnaires.get_answer!(answer.id) |> Questionnaires.with_question_and_choices
    end

    test "delete_answer/1 deletes the answer", %{answer: answer} do
      assert {:ok, %Answer{}} = Questionnaires.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Questionnaires.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset", %{answer: answer} do
      assert %Ecto.Changeset{} = Questionnaires.change_answer(answer)
    end
  end
end
