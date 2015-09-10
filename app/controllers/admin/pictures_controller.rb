class Admin::PicturesController < Admin::ApplicationController
  def resource_params
    params.require(:picture).permit!
  end

end
