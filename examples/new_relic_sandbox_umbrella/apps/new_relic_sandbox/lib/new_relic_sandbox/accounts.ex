defmodule NewRelicSandbox.Accounts do
  @moduledoc """
  The Accounts context.
  """

  use NewRelicAddons.Decorators
  import Ecto.Query, warn: false
  alias NewRelicSandbox.Repo

  alias NewRelicSandbox.Accounts.User

  @decorate_all new_relic_event()

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    # check logging of nested async task with async preload
    fn ->
      fn ->
        Repo.all(
          from u in User,
            preload: [:avatar, :articles]
        )
      end
      |> Task.async()
      |> Task.await()
    end
    |> Task.async()
    |> Task.await()

    # check logging of 2nd async task with sync preload
    fn ->
      User
      |> Repo.all()
      |> Repo.preload([:avatar, :articles], in_parallel: false)
    end
    |> Task.async()
    |> Task.await()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Removes user accounts that were not modified in specified duration.

  ## Examples

      iex> delete_old_users(5)

  """
  def delete_old_users(remove_before_sec) do
    remove_before = DateTime.add(DateTime.utc_now(), -remove_before_sec)

    Repo.delete_all(from(u in User, where: u.updated_at < ^remove_before))
  end

  alias NewRelicSandbox.Accounts.Avatar

  @doc """
  Returns the list of avatars.

  ## Examples

      iex> list_avatars()
      [%Avatar{}, ...]

  """
  def list_avatars do
    Repo.all(Avatar)
  end

  @doc """
  Gets a single avatar.

  Raises `Ecto.NoResultsError` if the Avatar does not exist.

  ## Examples

      iex> get_avatar!(123)
      %Avatar{}

      iex> get_avatar!(456)
      ** (Ecto.NoResultsError)

  """
  def get_avatar!(id), do: Repo.get!(Avatar, id)

  @doc """
  Creates a avatar.

  ## Examples

      iex> create_avatar(%{field: value})
      {:ok, %Avatar{}}

      iex> create_avatar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_avatar(attrs \\ %{}) do
    %Avatar{}
    |> Avatar.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a avatar.

  ## Examples

      iex> update_avatar(avatar, %{field: new_value})
      {:ok, %Avatar{}}

      iex> update_avatar(avatar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_avatar(%Avatar{} = avatar, attrs) do
    avatar
    |> Avatar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Avatar.

  ## Examples

      iex> delete_avatar(avatar)
      {:ok, %Avatar{}}

      iex> delete_avatar(avatar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_avatar(%Avatar{} = avatar) do
    Repo.delete(avatar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking avatar changes.

  ## Examples

      iex> change_avatar(avatar)
      %Ecto.Changeset{source: %Avatar{}}

  """
  def change_avatar(%Avatar{} = avatar) do
    Avatar.changeset(avatar, %{})
  end
end
