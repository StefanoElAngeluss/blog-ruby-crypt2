class StaticPagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:landing_page, :privacy_policy]
  def landing_page
  	@posts = Post.post_recent.published.limit(6)
  end

  def privacy_policy
  end
end
