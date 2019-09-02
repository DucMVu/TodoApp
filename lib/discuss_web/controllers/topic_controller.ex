defmodule DiscussWeb.TopicController do
	use DiscussWeb, :controller

	alias DiscussWeb.Topic
	alias Discuss.Repo

	def index(conn, _params) do
		topics = Repo.all(Topic)

		render conn, "index.html", topics: topics
	end

  def new(conn, _params) do
		changeset = Topic.changeset(%Topic{}, %{})

		render conn, "new.html", changeset: changeset
	end
	
	def create(conn, %{"topic" => topic}) do
		changeset = Topic.changeset(%Topic{}, topic)

		case Repo.insert(changeset) do
			{:ok, post} -> 
				# run 'mix phx.routes' in terminal to find out 'topic_path'
				redirect conn, to: Routes.topic_path(conn, :index)
			{:error, changeset} ->
				render conn, "new.html", changeset: changeset
		end
	end
end
