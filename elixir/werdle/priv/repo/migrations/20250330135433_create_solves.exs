defmodule Werdle.Repo.Migrations.CreateSolves do
  use Ecto.Migration

  def change do
    create table(:solves) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
