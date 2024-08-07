defmodule HabitsWeb.ChainJSON do
  alias Habits.Chains.Chain

  @doc """
  Renders a list of chains.
  """
  def index(%{chains: chains}) do
    %{data: for(chain <- chains, do: data(chain))}
  end

  @doc """
  Renders a single chain.
  """
  def show(%{chain: chain}) do
    %{data: data(chain)}
  end

  defp data(%Chain{} = chain) do
    %{
      id: chain.id,
      name: chain.name,
      type: chain.type,
      active: chain.active
    }
  end
end
