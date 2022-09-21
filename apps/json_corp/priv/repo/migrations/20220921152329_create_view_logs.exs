defmodule JsonCorp.Repo.Migrations.CreateViewLogs do
  use Ecto.Migration

  def change do
    create table(:view_logs) do
      add :session_id, :uuid, null: false
      add :uri, :string, null: false
      add :created_at, :timestamp, null: false
    end

    create index(:view_logs, [:created_at])
  end
end
