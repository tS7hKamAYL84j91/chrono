# web/controllers/auth_controller.ex
defmodule ChronoWeb.AuthController do
  use ChronoWeb, :controller
  plug Ueberauth

  alias Chrono.User
  alias Chrono.Repo

  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, first_name: auth.info.first_name, last_name: auth.info.last_name, email: auth.info.email, provider: "google"}
    changeset = User.changeset(%User{}, user_params)
    
    create(conn, changeset)
  end

  def create(conn, changeset) do
    case insert_or_update_user(conn, changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect("/")
    end
  end

  defp insert_or_update_user(conn, changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        render conn, "new.html", changeset: changeset
        # Repo.insert(changeset)
      user ->
        {:ok, user}
    end
   end

   def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end


end
