defmodule NewRelicSandbox.Accounts.Avatar do
  use Ecto.Schema
  import Ecto.Changeset
  alias NewRelicSandbox.Accounts.User

  schema "avatars" do
    belongs_to :user, User

    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(avatar, attrs) do
    avatar
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
