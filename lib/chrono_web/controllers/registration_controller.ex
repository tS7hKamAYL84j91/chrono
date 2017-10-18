defmodule ChronoWeb.RegistrationController do
	use ChronoWeb, :controller
	plug Ueberauth

	alias Chrono.User
	alias Chrono.Repo

	def create(conn, %{"user" => user_params}) do
		changeset = User.changeset(%User{}, user_params)

		case Repo.insert(changeset) do
			{:ok, struct} ->
		      	conn
		      	   |> put_flash(:info, "Thank you for signing in!")
		           |> put_session(:user_id, struct.id)
		           |> redirect(to: "/")
      		{:error, _changeset} ->
     	    # show error message
     	    		IO.inspect changeset.errors
     	            conn
			        |> put_flash(:error, "Error signing in")
			        |> redirect(to: "/")
     	end
  	end

end