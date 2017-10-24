defmodule Chrono.Either do
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