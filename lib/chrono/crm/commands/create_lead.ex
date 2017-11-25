defmodule Chrono.CRM.Commands.CreateLead do
  defstruct [
    :email_address,
    :family_name,
    :given_name,
    :opt_in
  ]

  use Vex.Struct

  validates :email_address, presence: true,
                            length: [min: 4],
                            format: ~r/(\w+)@([\w.]+)/
  validates :family_name,   presence: true,
                            format: ~r/^[a-z ,.'-]+$/i
  validates :given_name,    presence: true,
                            format: ~r/^[a-z ,.'-]+$/i
  validates :opt_in,        presence: true,
                            acceptance: true

end