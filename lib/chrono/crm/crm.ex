defmodule Chrono.CRM do
  alias Chrono.CRM.Contact
  alias Chrono.CRM.Commands.CreateLead
  alias GSS.Spreadsheet

  

  require Logger
  
  def register_interest(email_address, last_name, first_name, opt_in) do
    with {:ok, lead} <- %Contact{} 
      |> Contact.execute(%CreateLead{email_address: email_address,
        family_name: last_name, given_name: first_name, opt_in: opt_in}),
      :ok <- Spreadsheet.append_row(:gss_event_store, 1, lead |> Map.from_struct |> Enum.map(fn {_, v} -> v end) )
    do
      {:ok, lead}
    else
      {:error, e} ->  Logger.warn warning(e)
                      {:error, e}
      e -> Logger.warn warning(e)
          {:error, e}
    end
  end

  defp warning(e), do: "Danger will robinson #{inspect __MODULE__}: #{inspect e}"
end