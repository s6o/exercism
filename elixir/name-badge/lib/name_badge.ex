defmodule NameBadge do
  @spec print(id :: nil | String.t(), name :: String.t(), department :: nil | String.t()) ::
          String.t()
  def print(id, name, department) do
    suffix = "#{name} - #{if is_nil(department), do: "OWNER", else: String.upcase(department)}"
    prefix = if is_nil(id), do: "", else: "[#{id}] - "
    "#{prefix}#{suffix}"
  end
end
