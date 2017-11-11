defmodule LukimatWeb.Api.Serializer do
  def form_to_json(form) do
    %{
      id: form.id,
      name: form.name,
      level: form.level,
      questions: questions_to_json(form.questions),
      inserted_at: form.inserted_at,
      updated_at: form.updated_at
    }
  end

  def questions_to_json(questions) do
    Enum.map(questions, fn question ->
      %{
        id: question.id,
        form_id: question.form_id,
        content: question.content,
        correct_answer: question.correct_answer,
        question_type: question.type,
        audio: Lukimat.QuestionAudio.url({question.audio, question}, :original),
        inserted_at: question.inserted_at,
        updated_at: question.updated_at,
        choices: choices_to_json(question.choices)
      }
    end)
  end

  def choices_to_json(choices) do
    Enum.map(choices, fn choice ->
      %{
        question_id: choice.question_id,
        id: choice.id,
        content: choice.content,
        url: choice.url,
        image: Lukimat.ChoiceImage.url({choice.image, choice}, :original),
        inserted_at: choice.inserted_at,
        updated_at: choice.updated_at
      }
    end)
  end

  def answers_to_json(answers) do
    Enum.map(answers, fn %{"question_id" => question_id, "answer" => answer } ->
      %{
        question_id: question_id,
        answer: answer
      }
    end)
  end
end
