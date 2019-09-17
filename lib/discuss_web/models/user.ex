defmodule DiscussWeb.User do
  use DiscussWeb, :model

  @derive {Jason.Encoder, only: [:email]}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :full_email, :string
    has_many :topics, DiscussWeb.Topic
    has_many :comments, DiscussWeb.Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token, :full_email])
    |> validate_required([:email, :provider, :token, :full_email])
  end
end
