defmodule LukimatWeb.LayoutView do
  use LukimatWeb, :view

  def active_path?(conn, resource) do
    if resource != "" && String.contains?(conn.request_path, resource) do
      "active"
    else
      ""
    end
  end

  def has_role?(%{ :role => current_role }, roles) do
    Enum.member?(roles, current_role)
  end

  def has_role?(_, _) do
    false
  end
end
