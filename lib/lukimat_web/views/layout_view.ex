defmodule LukimatWeb.LayoutView do
  use LukimatWeb, :view

  def active_path?(conn, resource) do
    if resource != "" && String.contains?(conn.request_path, resource) do
      "active"
    else
      ""
    end
  end
end
