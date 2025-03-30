defmodule WerdleWeb.WordLive.Index do
  use WerdleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:cell_backgrounds, %{})
      |> assign(:keyboard_backgrounds, %{})
      |> assign(:changeset, nil)

    {:ok, socket}
  end
end
