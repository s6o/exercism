# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seed_002_solves.exs

alias Werdle.WordBank

"priv/repo/solves-data.csv"
|> File.stream!()
|> NimbleCSV.RFC4180.parse_stream()
|> Enum.each(fn [solve] -> WordBank.create_solve(%{"name" => solve}) end)

#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Werdle.Repo.insert!(%Werdle.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
