class PicturesController < ApplicationController
  def resource_params
    params.require(:picture).permit!
  end

  def index
    redirect_to "/"
  end
end
