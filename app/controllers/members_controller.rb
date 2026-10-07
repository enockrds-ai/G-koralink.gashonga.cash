class MembersController < ApplicationController
  def index
    @members=Member.order(created_at: :asc)
  end
end
