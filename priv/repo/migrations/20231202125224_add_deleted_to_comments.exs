defmodule JsonCorp.Repo.Migrations.AddDeletedToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :deleted_at, :utc_datetime_usec, null: true
    end

    drop index(:comments, [:post_slug, :inserted_at])
    create index(:comments, [:post_slug, :inserted_at], where: "deleted_at IS NULL")
  end
end
