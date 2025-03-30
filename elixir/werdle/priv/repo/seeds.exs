# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

File.ls!("priv/repo/")
|> Enum.filter(fn f -> String.starts_with?(f, "seed_") end)
|> Enum.each(fn f -> System.cmd("mix", ["run", f]) end)
