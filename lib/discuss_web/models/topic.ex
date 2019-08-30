defmodule Discuss.Topic do
  use DiscussWeb, :model

  # find table 'topic' with 'title' field
  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    # struct (like JS object) is a record in database
    # params and struct have similar structure. Params contains properties to be updated by struct
    struct
    # produces a changeset
    |> cast(params, [:title])
    # adds errors to changeset, 'title' is a must-have (can't be blank)
    |> validate_required([:title])
  end
end