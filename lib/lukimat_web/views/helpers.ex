defmodule LukimatWeb.ViewHelpers do
  def has_role?(%{ :role => current_role }, roles) do
    Enum.member?(roles, current_role)
  end

  def has_role?(_, _) do
    false
  end
end

