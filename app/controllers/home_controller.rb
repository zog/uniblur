class HomeController < ApplicationController
  def index
    @pictures = Picture.ready.page(params[:page] || 1).order('created_at DESC')
  end
end
