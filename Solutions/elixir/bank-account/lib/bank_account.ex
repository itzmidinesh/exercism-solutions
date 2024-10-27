defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {:ok, account} = Agent.start_link(fn -> %{balance: 0, closed: false} end)
    account
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    Agent.update(account, fn state -> %{state | closed: true} end)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    Agent.get(account, fn %{balance: balance, closed: closed} ->
      if closed, do: {:error, :account_closed}, else: balance
    end)
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(account, amount) when amount > 0 do
    Agent.get_and_update(account, fn %{balance: balance, closed: closed} = state ->
      case closed do
        true -> {{:error, :account_closed}, state}
        false -> {:ok, %{state | balance: balance + amount}}
      end
    end)
  end

  def deposit(_, _), do: {:error, :amount_must_be_positive}

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(account, amount) when amount > 0 do
    Agent.get_and_update(account, fn %{balance: balance, closed: closed} = state ->
      cond do
        closed -> {{:error, :account_closed}, state}
        amount > balance -> {{:error, :not_enough_balance}, state}
        true -> {:ok, %{state | balance: balance - amount}}
      end
    end)
  end

  def withdraw(_, _), do: {:error, :amount_must_be_positive}
end
