class PicturesController < ApplicationController
  def resource_params
    params.require(:picture).permit!
  end

  def index
    redirect_to "/"
  end

  def create
    save_resource
    render json: {status: 'success'}
  end
end
