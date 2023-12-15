defmodule LiveViewSvelteOfflineDemo.Repo.Migrations.CreateUserStates do
  use Ecto.Migration

  def change do
    create table(:user_states) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :state, :map, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_states, [:user_id])
  end
end
