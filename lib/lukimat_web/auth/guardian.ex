defmodule LukimatWeb.Guardian do
  use Guardian, otp_app: :lukimat,
    permissions: %{
      user: [:admin, :student, :teacher],
    }
  use Guardian.Permissions.Bitwise
  alias Lukimat.Repo
  alias Lukimat.Accounts.User
  require IEx

  def subject_for_token(user = %User{}, _claims) do
    {:ok, "User:" <> to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  def resource_from_claims(%{"sub" => "User:" <> uid_str}) do
    try do
      case Integer.parse(uid_str) do
        {uid, ""} ->
          {:ok, Repo.get!(User, uid)}
        _ ->
          {:error, :invalid_id}
      end
    rescue
        Ecto.NoResultsError -> {:error, :no_result}
    end
  end

  def resource_from_claims(_) do
    {:error, :invalid_claims}
  end

  def build_claims(claims, resource, opts) do
    claims =
      claims
          |> encode_permissions_into_claims!(user_permissions(resource))
    {:ok, claims}
  end

  def user_permissions(%{role: role}) do
    permissions =
      case role do
        "student" -> [:student]
        "teacher" -> [:teacher]
        "admin" -> [:admin]
        _ -> []
      end
    %{ user: permissions }
  end
end
