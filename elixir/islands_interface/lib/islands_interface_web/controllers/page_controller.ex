defmodule IslandsInterfaceWeb.PageController do
  use IslandsInterfaceWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
