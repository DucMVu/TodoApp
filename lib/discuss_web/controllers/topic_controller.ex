defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias DiscussWeb.Topic
  alias Discuss.Repo

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, params) do
    # topics = Repo.all(Topic)
    page = Topic |> Repo.paginate(params)

    render(conn, "index.html",
      topics: page.entries,
      page: page
      # page_number: page.page_number,
      # page_size: page.page_size
    )
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)

    render(conn, "show.html", topic: topic)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "New topic created!")
        # run 'mix phx.routes' in terminal to find out 'topic_path'
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # edit handler gets called with id of topic to be changed
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated!")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    result =
      Repo.get!(Topic, topic_id)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.foreign_key_constraint(:comments, name: "comments_topic_id_fkey")
      |> Repo.delete()

    case result do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Topic deleted!")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Can't be deleted because there are comments!")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
