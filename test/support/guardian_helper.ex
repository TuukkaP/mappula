defmodule LukimatWeb.GuardianHelper do
  use Phoenix.ConnTest
  import LukimatWeb.Router.Helpers

  @endpoint LukimatWeb.Endpoint

  def sign_in(conn, user, password \\ "password") do
      post conn, session_path(conn, :create), session: %{email: user.email, password: password}
  end
end
