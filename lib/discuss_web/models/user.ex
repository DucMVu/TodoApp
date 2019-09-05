defmodule DiscussWeb.User do
  use DiscussWeb, :model

  # find table 'topic' with 'title' field
  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :nickname, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token, :nickname])
    |> validate_required([:email, :provider, :token, :nickname])
  end
end