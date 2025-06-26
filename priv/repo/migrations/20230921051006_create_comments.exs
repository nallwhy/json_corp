defmodule JsonCorp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :post_slug, :string, null: false
      add :session_id, :uuid, null: false
      add :name, :string, null: false
      add :email, :string, null: false
      add :body, :string, size: 1000, null: false
      add :confirmed_at, :timestamptz, null: true
      timestamps()
    end

    create index(:comments, [:post_slug, :inserted_at])
  end
end
