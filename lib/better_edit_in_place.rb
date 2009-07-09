module BetterEditInPlace
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     edit_in_place_for :post, :title
  #   end
  #
  module ClassMethods
    def edit_in_place_for(object, attribute, options = {})
      define_method("set_#{object}_#{attribute}") do
        @item = object.to_s.camelize.constantize.find(params[:id])
        @item.send("#{attribute}=", params["#{object}"]["#{attribute}"])
        respond_to do |format|
          format.html {}
          format.json {
            if @item.save
              render :json => @item.to_json(:only => [:id], :methods => ["#{attribute}"])
            else
              render :json => @item.errors.to_json, :status => 500
            end
          }
        end
      end
    end
  end
end
