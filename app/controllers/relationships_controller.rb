class RelationshipsController < ApplicationController
  before_action :require_user
  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    if current_user.can_follow?(leader)
      Relationship.create(follower: current_user, leader_id: params[:leader_id])
    elsif current_user == leader
      flash[:danger] = "You cannot follow yourself"
    else
      flash[:danger] = "You are already following #{User.find(params[:leader_id]).full_name}"
    end
    redirect_to people_path
  end

  def destroy
    relationship = current_user.following_relationships.where(id: params[:id]).first
    relationship.destroy if relationship
    redirect_to people_path
  end
end