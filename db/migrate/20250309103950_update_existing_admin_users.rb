class UpdateExistingAdminUsers < ActiveRecord::Migration[7.2]
  def up
    # Update user_type to 'admin' for all users where admin=true
    execute <<-SQL
      UPDATE users
      SET user_type = 'admin'
      WHERE admin = TRUE;
    SQL
  end

  def down
    # No need to roll back since this is a data migration
  end
end
