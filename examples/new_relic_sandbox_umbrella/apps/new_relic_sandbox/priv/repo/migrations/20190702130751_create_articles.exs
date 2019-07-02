defmodule NewRelicSandbox.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:articles, [:author_id])
  end
end
