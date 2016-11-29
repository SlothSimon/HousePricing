class WorksController < ApplicationController


  before_action :login, only: [:ajax]

  @@work_id=0
  def ajax
    @@work_id=@@work_id+1
    house=House.find_by(id: @@work_id)
    # 避免重复抓取
    while (not house) or (not house.works_houses.blank?)
        @@work_id= @@work_id+1
        house=House.find_by(id: @@work_id)
        break if @@work_id>House.last.id
    end
    if @@work_id> House.last.id
        redirect_to works_path, flash: {:success => "抓取完毕"}
        else
        respond_to do |format|
            format.json { render :json => house }
        end
    end
  end

  def index
    render 'shared/index', :locals => {:post_url => works_path, :get_url => ajax_works_path, :keyword => '写字楼'}
  end

  def create
    @house=House.find_by(id: params[:id])
    @house.works_houses.delete_all
    params[:info].split(',').each do |row|
      attr=row.split('/')
      work=Work.find_by(longitude: attr[1], latitude: attr[2])
      if work.nil?
          work=Work.new(name: attr[0], longitude: attr[1], latitude: attr[2])
          work.save
      end
      WorksHouses.create(work_id: work.id, house_id: @house.id, distance: attr[3])
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
