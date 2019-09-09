defmodule DiscussWeb.Comment do
  use DiscussWeb, :model

  @derive {Jason.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string
    belongs_to :user, DiscussWeb.User
    belongs_to :topic, DiscussWeb.Topic

    timestamps()

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:content])
      |> validate_required([:content])
    end
  end
end