# defmodule Discuss.Repo.Migrations.UpdateFkOnComments do
#   use Ecto.Migration

#   def change do
#     alter table("comments") do
#       modify :topic_id, references("topics", on_delete: :delete_all), from: references("topics") 
#     end
#   end
# end
