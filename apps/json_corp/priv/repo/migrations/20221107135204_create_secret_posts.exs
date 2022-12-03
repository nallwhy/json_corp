defmodule JsonCorp.Repo.Migrations.CreateSecretPosts do
  use Ecto.Migration

  def change do
    create table(:secret_posts) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :category, :string, null: false
      add :slug, :string, null: false
      add :body, :text, null: false
      add :date_created, :date, null: false
      add :cover_url, :string, null: true
      add :password, :string, null: false

      timestamps()
    end

    create unique_index(:secret_posts, [:slug])
  end
end
