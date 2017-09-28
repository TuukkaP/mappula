defmodule LukimatWeb.CurrentUser do
  import Plug.Conn
  import LukimatWeb.Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :current_user, current_resource(conn))
  end
end


defmodule LukimatWeb.TestLog do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.puts "TESTLOG"
    IO.puts "TESTLOG"
    IO.inspect fetch_session(conn, :private)
    IO.puts "TESTLOG"
    IO.puts "TESTLOG"
    conn
  end
end
