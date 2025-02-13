defmodule HabitsWeb.ChainJSON do
  alias Habits.Chains.Chain

  def index(%{chains: chains}) do
    for(chain <- chains, do: data(chain))
  end

  def show(%{chain: chain}) do
    data(chain)
  end

  defp data(%Chain{} = chain) do
    Map.take(chain, [:id, :name, :type, :active, :descripton, :order, :aggregate])
  end
end
