defmodule Lukimat.Questionnaires.Choice do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires.Choice


  schema "choices" do
    field :content, :string
    field :url, :string
    field :image, Lukimat.ChoiceImage.Type

    timestamps()
    belongs_to :question, Lukimat.Questionnaires.Question
  end

  @doc false
  def changeset(%Choice{} = choice, attrs) do
    choice
    |> cast(attrs, [:content, :url, :question_id])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:content, :question_id])
  end


  #def cast_image(changeset, %{image: upload}) do
  #  IO.inspect changeset
  #  IO.inspect upload
  #  case upload do
  #    %Plug.Upload{} ->
  #      image_hash = 
  #        :crypto.hash(:sha, upload.filename) |> Base.encode16
  #        |> String.slice(1..10)
  #        |> String.downcase
  #      IO.puts image_hash
  #      image_path = "/uploads/choices/choice_#{image_hash}#{Path.extname(upload.filename)}"
  #      upload_path = Path.expand("priv#{image_path}")
  #      IO.puts image_path 
  #      IO.puts upload_path
  #      File.cp!(upload.path, upload_path)
  #      put_change(changeset, :image, image_path)
  #    _ ->
  #      changeset
  #  end
  #end
end
