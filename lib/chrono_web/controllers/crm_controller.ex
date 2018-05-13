defmodule ChronoWeb.CrmController do
  @recaptcha_url Application.get_env(:chrono, :recaptcha_url)
  @recaptcha_secret Application.get_env(:chrono, :recaptcha_secret)
  @headers [{"Content-Type", "application/x-www-form-urlencoded"}, {"Accept", "text/html"}]

  use ChronoWeb, :controller
  require Logger

  def create(
        conn,
        %{
          "firstname" => first_name,
          "lastname" => last_name,
          "email" => email_address,
          "opt_in" => opt_in,
          "g-recaptcha-response" => captcha_token
        } = params
      ) do
    with {:ok, true} <- captcha_token |> validate_recaptcha,
         {:ok, _lead} <-
           Chrono.CRM.register_interest(
             email_address,
             last_name,
             first_name,
             opt_in |> parse_opt_in
           ) do
      conn
      |> put_flash(:info, "Thanks for registering we'll be in touch soon")
      |> redirect(to: "/#contact")

      # |> Plug.Conn.send_resp(201,"Thanks for your registraiton #{inspect lead}, we'll be touch")
    else
      resp ->
        Logger.info("Dodgey submission #{inspect(params)} - #{inspect(resp)}")

        conn
        |> put_flash(
          :error,
          "There was a problem with your submission, please make sure you filled in all the details correctly"
        )
        |> redirect(to: "/#contact")

        # |> Plug.Conn.send_resp(400,"There was an error processing your registration, please try again latter")
    end
  end

  def parse_opt_in("on"), do: "yes"
  def parse_opt_in(_), do: "no"

  def validate_recaptcha(token) do
    with req_body <- [secret: @recaptcha_secret, response: token] |> recaptcha_body,
         {:ok, %HTTPoison.Response{status_code: 200, body: resp_body}} <-
           HTTPoison.post(@recaptcha_url, req_body, @headers),
         {:ok, %{"success" => true}} <- resp_body |> Poison.decode() do
      {:ok, true}
    else
      {:ok, %{"success" => false, "error-codes" => err_codes}} ->
        Logger.info("Danger Will Robinson #{inspect(err_codes)}")
        {:ok, false}

      {:error, err} ->
        Logger.warn("Danger Will Robinson #{inspect(err)}")
        {:error, err}

      {:ok, %HTTPoison.Response{status_code: x}} ->
        Logger.warn("Danger Will Robinson Status #{x}")
        {:error, "HTTP Status Fail"}

      _ ->
        Logger.warn("Danger Will Robinson let it fail")
        {:error, "What ever!"}
    end
  end

  def recaptcha_body(params) do
    params
    |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
    |> Enum.join("&")
  end
end
