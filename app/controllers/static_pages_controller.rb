class StaticPagesController < ApplicationController
  require 'flickr'
  require 'figaro'
  def index

  end

  def search_flickr
    flickr = Flickr.new Figaro.env.flickr_api_key, Figaro.env.flickr_secret
    id = params[:query]

    begin
      response = flickr.photos.search(user_id: id)
      @photo_urls = response.map do |photo|
        url = flickr.photos.getSizes(photo_id: photo.id).find { |size| size.label == 'Medium' }.source
        url
      end
    rescue Flickr::FailedResponse => e
      @photo_urls = nil
      flash[:notice] = e.message
    end
    render 'index'
  end

end
