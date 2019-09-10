defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias DiscussWeb.{Topic, Comment}
  alias Discuss.Repo

  import Ecto.Query

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)

    topic =
      Topic
      |> preload(comments: [:user])
      |> Repo.get(topic_id)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset =
      topic
      # build association with both current topic and current user
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: Repo.preload(comment, :user)})
        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
