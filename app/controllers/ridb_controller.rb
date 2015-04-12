class RidbController < ApplicationController

  before_filter :check_referer_host

  respond_to :json

  def get_recreation_areas
    render(nothing: true) and return if params[:state].blank? || params[:name].blank?

    ridb = RIDB::Client.new(Rails.application.secrets.ridb_api_key)
    result = ridb.recreation_areas_by_state(params[:state])
    items = result.list(query: params[:name]).items

    render json: items.map(&:data).sort_by {|r| r['RecAreaName'] }
  end

end