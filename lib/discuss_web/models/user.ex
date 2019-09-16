defmodule DiscussWeb.User do
  use DiscussWeb, :model

  # @derive {Jason.Encoder, only: [:nickname]}
  @derive {Jason.Encoder, only: [:email]}

  # find table 'topic' with 'title' field
  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    # field :nickname, :string
    has_many :topics, DiscussWeb.Topic
    has_many :comments, DiscussWeb.Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    # |> cast(params, [:email, :provider, :token, :nickname])
    # |> validate_required([:email, :provider, :token, :nickname])
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
