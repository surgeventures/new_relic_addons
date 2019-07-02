defmodule NewRelicSandbox.Blog.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias NewRelicSandbox.Accounts.User

  schema "articles" do
    belongs_to :author, User

    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
