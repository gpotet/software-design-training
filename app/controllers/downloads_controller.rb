class DownloadsController < ApplicationController
  def index
    downloaded_items = Download.includes(:item).where(user: current_user).map(&:item)
    downloaded_items_by_kind = downloaded_items.group_by { |item| item.kind + 's' }
    render json: downloaded_items_by_kind
  end
end
