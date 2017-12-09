defmodule Chrono.CRM.Contact do

  alias Chrono.CRM.Contact
  alias Chrono.CRM.Commands.{CreateLead}
  alias Chrono.CRM.Events.{LeadGenerated}

  defstruct [
    :email_address,
    :family_name,
    :given_name,
    :last_updated,
    :source_type,
    :opt_in
  ]

  @type state :: struct
  @type command :: struct
  @type event :: struct

  @spec execute(state, command) :: event
  def execute(%Contact{}, %CreateLead{}=cl) do
    case cl |> Vex.valid? do
      true -> {:ok, %LeadGenerated{
              dttm: NaiveDateTime.utc_now,
              source: "WebApp",
              email_address: cl.email_address,
              family_name: cl.family_name,
              given_name: cl.given_name,
              opt_in: cl.opt_in }}
      false -> {:error, "invlaid CreateLead command"} 
    end 

  end


  
end