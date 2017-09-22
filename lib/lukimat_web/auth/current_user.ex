defmodule LukimatWeb.CurrentUser do
  import Plug.Conn
  import LukimatWeb.Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :current_user, current_resource(conn))
  end
end
