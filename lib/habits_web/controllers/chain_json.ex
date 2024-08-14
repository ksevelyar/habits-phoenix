defmodule HabitsWeb.ChainJSON do
  alias Habits.Chains.Chain

  def index(%{chains: chains}) do
    for(chain <- chains, do: data(chain))
  end

  def show(%{chain: chain}) do
    data(chain)
  end

  defp data(%Chain{} = chain) do
    %{
      id: chain.id,
      name: chain.name,
      type: chain.type,
      active: chain.active,
      description: chain.description
    }
  end
end
