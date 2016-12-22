class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def update
    begin
      update_queue_items
      current_user.normalize_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position entry"
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user == queue_item.user
    current_user.normalize_positions
    redirect_to my_queue_path
  end

  private

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item|
        item = QueueItem.find(queue_item['id'])
        if current_user == item.user
          item.update_attributes!(
            position: queue_item['position'], 
            rating: queue_item['rating']
          )
        end
      end
    end
  end

  def queue_video(video)
    QueueItem.create(
      user: current_user, 
      video: video,
      position: new_queue_item_position
    ) if video_already_queued?(video)
  end

  def new_queue_item_position
    QueueItem.count + 1
  end

  def video_already_queued?(video)
    QueueItem.where(video: video, user: current_user).count == 0
  end
end