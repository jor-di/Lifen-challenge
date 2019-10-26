class AddIndexOnPractitioner < ActiveRecord::Migration[5.2]
  def change
    # This is implemented to improve API v1 communication's create method performance.
    add_index :practitioners, [:last_name, :first_name]
  end
end
