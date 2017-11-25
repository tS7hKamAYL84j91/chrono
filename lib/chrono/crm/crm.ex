defmodule Chrono.CRM do
  alias Chrono.CRM.Contact
  alias Chrono.CRM.Commands.CreateLead

  require Logger
  
  def register_interest(email_address, last_name, first_name, opt_in) do
    %Contact{} 
    |> Contact.execute(%CreateLead{email_address: email_address,
      family_name: last_name, given_name: first_name, opt_in: opt_in}) 
  end

end