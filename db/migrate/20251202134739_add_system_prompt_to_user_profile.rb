class AddSystemPromptToUserProfile < ActiveRecord::Migration[7.2]
  def change
    add_column :user_profiles, :system_prompt, :text
  end
end
