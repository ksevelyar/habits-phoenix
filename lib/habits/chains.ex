defmodule Habits.Chains do
  import Ecto.Query, warn: false
  alias Habits.Repo

  alias Habits.Chains.Chain

  def list_chains(user_id) do
    Repo.all(from c in Chain, where: c.user_id == ^user_id)
  end

  def get_chain!(user_id, chain_id) do
    query = from c in Chain, where: c.id == ^chain_id and c.user_id == ^user_id

    case Repo.one(query) do
      nil -> raise Ecto.NoResultsError, queryable: query
      result -> result
    end
  end

  def create_chain(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:chains, attrs)
    |> Chain.changeset(attrs)
    |> Repo.insert()
  end

  def update_chain(%Chain{} = chain, attrs) do
    chain
    |> Chain.changeset(attrs)
    |> Repo.update()
  end

  def delete_chain(%Chain{} = chain) do
    Repo.delete(chain)
  end

  def change_chain(%Chain{} = chain, attrs \\ %{}) do
    Chain.changeset(chain, attrs)
  end
end
