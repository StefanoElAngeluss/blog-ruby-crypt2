class AddPublishedToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :published, :boolean, default: false
    add_column :posts, :published_at, :datetime
  end
end
