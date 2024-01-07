# ---
# Excerpted from "Real-Time Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/sbsockets for more book information.
# ---
defmodule Sneakers23Web.ProductController do
  use Sneakers23Web, :controller

  def index(conn, _params) do
    {:ok, products} = Sneakers23.Inventory.get_complete_products()

    conn
    |> assign(:products, products)
    |> render("index.html")
  end

  def products(conn, _params) do
    {:ok, products} = Sneakers23.Inventory.get_complete_products()

    # The initial approach of using @derive on the Product's Ecto schema just
    # ignored the :items member which is required to render the available sizes
    # correctly - atm this is the best I've come up with
    ms =
      products
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(fn m ->
        pm = Map.delete(m, :__meta__)

        Map.put(
          pm,
          :items,
          Enum.map(pm.items, fn s ->
            Map.from_struct(s)
            |> Map.delete(:__meta__)
            |> Map.delete(:product)
          end)
        )
      end)

    json(conn, ms)
  end
end
