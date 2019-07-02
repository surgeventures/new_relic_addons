defmodule NewRelicSandbox.Repo.Migrations.CreateAvatars do
  use Ecto.Migration

  def change do
    create table(:avatars) do
      add :url, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:avatars, [:user_id])
  end
end
