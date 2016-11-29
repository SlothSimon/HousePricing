class SubwaysController < ApplicationController

  before_action :login, only: [:ajax]

  @@subway_id=0

  def ajax
    @@subway_id=@@subway_id+1
    house=House.find_by(id: @@subway_id)
    # 避免重复抓取
    while (not house) or (not house.subways_houses.blank?)
        @@subway_id= @@subway_id+1
        house=House.find_by(id: @@subway_id)
        break if @@subway_id>House.last.id
    end
    if @@subway_id> House.last.id
        redirect_to subways_path, flash: {:success => "抓取完毕"}
        else
        respond_to do |format|
            format.json { render :json => house }
        end
    end
  end

  def index
    render 'shared/index', :locals => {:post_url => subways_path, :get_url => ajax_subways_path, :keyword => '地铁'}
  end

  def create
    @house=House.find_by(id: params[:id])
    @house.subways_houses.delete_all
    params[:info].split(',').each do |row|
      attr=row.split('/')
      subway=Subway.find_by(longitude: attr[1], latitude: attr[2])
      if subway.nil?
          subway=Subway.new(name: attr[0], longitude: attr[1], latitude: attr[2])
          subway.save
      end
      SubwaysHouses.create(subway_id: subway.id, house_id: @house.id, distance: attr[3])
    end
    render json: params.as_json
  end

  private

  def login
    if current_user.nil?
      redirect_to root_path, flash: {:warning => "只有管理员能进行此操作喔"}
    end
  end

end
