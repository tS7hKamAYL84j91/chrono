defmodule Chrono.Either do
  @moduledoc """
  Creates an either monad like response from standard elixir functions
  """
  
  @vsn 0.1
  
  defmacro either(expression) do
    quote do
      try do
        {:ok,unquote(expression)}
      rescue
        e -> {:error,e}
      end
    end
  end

end