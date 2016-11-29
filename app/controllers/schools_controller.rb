class SchoolsController < ApplicationController

  before_action :login, only: [:ajax]

  @@school_id=0

  def ajax
    @@school_id=@@school_id+1
    house=House.find_by(id: @@school_id)
    # 避免重复抓取
    while (not house) or (not house.schools_houses.blank?)
        @@school_id= @@school_id+1
        house=House.find_by(id: @@school_id)
        break if @@school_id>House.last.id
    end
    if @@school_id> House.last.id
        redirect_to schools_path, flash: {:success => "抓取完毕"}
        else
        respond_to do |format|
            format.json { render :json => house }
        end
    end
  end

  def index
    render 'shared/index', :locals => {:post_url => schools_path, :get_url => ajax_schools_path, :keyword => '学校'}
  end

  def create
    @house=House.find_by(id: params[:id])
    @house.schools_houses.delete_all
    params[:info].split(',').each do |row|
      attr=row.split('/')
      school=School.find_by(longitude: attr[1], latitude: attr[2])
      if school.nil?
          school=School.new(name: attr[0], longitude: attr[1], latitude: attr[2])
          school.save
      end
      SchoolsHouses.create(school_id: school.id, house_id: @house.id, distance: attr[3])
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
