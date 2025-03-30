# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seed_001_words.exs

alias Werdle.Repo
alias Werdle.WordBank.Word

dt = DateTime.utc_now() |> DateTime.truncate(:second)

WordList.getStream!()
|> Enum.filter(fn word -> String.length(word) == 5 end)
|> Enum.map(fn word -> %{name: word, inserted_at: dt, updated_at: dt} end)
|> Enum.chunk_every(1000)
|> Enum.each(fn wb -> Repo.insert_all(Word, wb) end)

#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Werdle.Repo.insert!(%Werdle.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
