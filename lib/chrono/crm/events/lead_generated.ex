defmodule Chrono.CRM.Events.LeadGenerated do
  @derive [Poison.Encoder]
  defstruct [
    :dttm,
    :source,
    :email_address,
    :family_name,
    :given_name,
    :opt_in
  ]
end