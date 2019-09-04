defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias DiscussWeb.User
	alias Discuss.Repo

  # might try another approach following ueberauth_example
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_data = %{token: auth.credentials.token, email: auth.info.email, provider: auth.provider}
    changeset = User.changeset(%User{}, user_data)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect to: Routes.topic_path(conn, :index)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect to: Routes.topic_path(conn, :index)
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

end