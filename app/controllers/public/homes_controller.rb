class Public::HomesController < ApplicationController

  layout 'top'

  def top
    @user = User.new
  end
end
