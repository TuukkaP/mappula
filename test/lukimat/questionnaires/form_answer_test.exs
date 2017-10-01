defmodule Lukimat.Questionnaires.FormAnswerTest do
  use Lukimat.DataCase

  alias Lukimat.Questionnaires
  alias Lukimat.Accounts

  describe "form_answers" do
    alias Lukimat.Questionnaires.FormAnswer

    @user_attrs %{class: "some class", email: "test@example.org", password: "password", password_confirmation: "password", first_name: "some first_name", language: "some language", last_name: "some last_name", role: "some role"}
    @form_attrs %{name: "Test form", level: "easy", questions: [%{content: "why?", correct_answer: "1", type: "text"}]}
    @update_attrs %{form_id: 1}
    @invalid_attrs %{}

    setup do
      {:ok, form} = Questionnaires.create_form(@form_attrs)
      {:ok, user} = Accounts.create_user(@user_attrs)

      question = form.questions |> List.first
      params = %{
        form_id: form.id, user_id: user.id,
        answers: [%{answer: 1, question_id: question.id}]
      }

      {:ok, form_answer} = Questionnaires.create_form_answer(params)

      {:ok, form_answer: form_answer, form_answer_params: params }
    end

    test "list_form_answers/0 returns all form_answers", %{form_answer: form_answer} do
      assert Questionnaires.list_form_answers() |> Questionnaires.with_form_and_user_and_answers == [form_answer]
    end

    test "get_form_answer!/1 returns the form_answer with given id", %{form_answer: form_answer} do
      assert Questionnaires.get_form_answer!(form_answer.id) |> Questionnaires.with_form_and_user_and_answers == form_answer
    end

    test "create_form_answer/1 with valid data creates a form_answer", %{form_answer_params: params} do
      assert {:ok, %FormAnswer{} = _ } = Questionnaires.create_form_answer(params)
    end

    test "create_form_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_form_answer(@invalid_attrs)
    end

    test "update_form_answer/2 with valid data updates the form_answer", %{form_answer: form_answer} do
      assert {:ok, form_answer} = Questionnaires.update_form_answer(form_answer, @update_attrs)
      assert %FormAnswer{} = form_answer
    end

    test "update_form_answer/2 with invalid data returns error changeset", %{form_answer: form_answer} do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.update_form_answer(form_answer, @invalid_attrs)
      assert form_answer == Questionnaires.get_form_answer!(form_answer.id)
    end

    test "delete_form_answer/1 deletes the form_answer", %{form_answer: form_answer} do
      assert {:ok, %FormAnswer{}} = Questionnaires.delete_form_answer(form_answer)
      assert_raise Ecto.NoResultsError, fn -> Questionnaires.get_form_answer!(form_answer.id) end
    end

    test "change_form_answer/1 returns a form_answer changeset", %{form_answer: form_answer} do
      assert %Ecto.Changeset{} = Questionnaires.change_form_answer(form_answer)
    end
  end
end
