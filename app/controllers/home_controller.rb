class HomeController < ApplicationController
  def index
    @known_user = known_user?
    @name = cookies[:name]
  end

  def leaderboard
    @votes = Vote.group('image_id').order('count(up) desc').select('image_id, count(up)').includes(:image).limit(40)
  end

  def set_name
    if User.find_by_name(params[:name]).nil?
      cookies[:name] = params[:name]
      User.create!(params.permit(:name)) 
    else
      flash[:error] = "Name already taken"
    end
    redirect_to root_path
  end

  def next_image
    vote = params[:vote]
    image = params[:img]
    record_vote(vote, image) if vote.present?
    render json: next_image_json
  end

  private

  def record_vote(vote, image_src)
    user = get_user
    image = Image.find_by_path(image_src)
    Vote.create!(image: image, up: vote == 'up', user: user)
  end

  def next_image_json
    image = Image.next_image(get_user)
    user = get_user
    res = {image: image.path, nopes: Vote.where(user: user, up: false).count, likes: Vote.where(user: user, up: true).count}
    res.to_json
  end

  def get_user
    User.find_by_name(cookies[:name])
  end

  def known_user?
    cookies[:name].present?
  end

end
