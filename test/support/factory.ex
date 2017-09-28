defmodule Lukimat.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Lukimat.Repo
  alias Lukimat.Questionnaires.{Choice, Question, Form, Answer}
  alias Lukimat.Accounts.User
  alias Lukimat.Schools.School

  def user_factory do 
    %User{
      first_name: "Teppo",
      last_name: "Tulppu",
      email: sequence(:email, &"email-#{&1}@example.com"),
      role: "teacher",
      language: "fi",
      class: "1A",
      encrypted_password: Comeonin.Bcrypt.hashpwsalt("password")
    }
  end

  def with_users(%School{} = school) do
    insert_pair(:user, school: school)
    school
  end

  def school_factory do
    %School{
      name: "Springfield elementary"
    }
  end

  def answer_factory do 
    %Answer{
      answer: "42",
      is_correct: true,
    }
  end

  def choice_factory do 
    %Choice{
      content: "Choice",
      url: "some url",
    }
  end

  def question_factory do 
    %Question{
      content: "Are you ready?",
      correct_answer: "42",
      type: "multiple_choice"
    }
  end

  def with_choice(%Question{} = question) do
    insert(:choice, question: question)
  end

  def form_factory do 
    %Form{
      name: "Test Form",
      level: "easy"
    }
  end

  def with_question(%Form{} = form) do
    insert(:question, form: form)
  end

end
