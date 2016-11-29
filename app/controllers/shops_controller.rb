class ShopsController < ApplicationController


  before_action :login, only: [:ajax]


  @@shop_id=0

  def ajax
    @@shop_id= @@shop_id+1
    house=House.find_by(id: @@shop_id)
    # 避免重复抓取
    while (not house) or (not house.shops_houses.blank?)
        @@shop_id= @@shop_id+1
        house=House.find_by(id: @@shop_id)
        break if @@shop_id>House.last.id
    end
    if @@shop_id> House.last.id
        redirect_to shops_url, flash: {:success => "抓取完毕"}
        else
        respond_to do |format|
            format.json { render :json => house }
        end
    end
  end

  def index
    render 'shared/index', :locals => {:post_url => shops_url, :get_url => ajax_shops_path, :keyword => '商场'}
  end

  def create
    @house=House.find_by(id: params[:id])
    @house.shops_houses.delete_all
    params[:info].split(',').each do |row|
      attr=row.split('/')
      shop=Shop.find_by(longitude: attr[1], latitude: attr[2])
      if shop.nil?
          shop=Shop.new(name: attr[0], longitude: attr[1], latitude: attr[2])
          shop.save
      end
      ShopsHouses.create(shop_id: shop.id, house_id: @house.id, distance: attr[3])
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
