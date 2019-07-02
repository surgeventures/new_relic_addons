defmodule NewRelicSandbox.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias NewRelicSandbox.Accounts.Avatar
  alias NewRelicSandbox.Blog.Article

  schema "users" do
    has_one :avatar, Avatar
    has_many :articles, Article, foreign_key: :author_id

    field :age, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age])
    |> validate_required([:name, :age])
  end
end
