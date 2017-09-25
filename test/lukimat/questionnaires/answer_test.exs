defmodule Lukimat.Questionnaires.AnswerTest do
  use Lukimat.DataCase

  alias Lukimat.Questionnaires


  describe "answers" do
    alias Lukimat.Questionnaires.Answer

    @valid_attrs %{answer: "42", is_correct: true}
    @update_attrs %{answer: "43", is_correct: false}
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
      assert answer.answer == "42"
      assert answer.is_correct == true
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questionnaires.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, answer} = Questionnaires.update_answer(answer, @update_attrs)
      assert %Answer{} = answer
      assert answer.answer == "43"
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
end
