class MaterialsController < ApplicationController
  before_action :set_material, only: [:edit, :update, :destroy]

  def index
    @materials = Material.all
    respond_to do |wants|
      wants.html
      wants.json  { render json: @materials.map { |m| {label: m.color, value: m.id} }.insert(0, {label: "", value: ""}), root: false }
    end
  end

  def new
    @material = Material.new
  end

  def edit
  end

  def update
    if @material.update_attributes material_params
      redirect_to materials_path, notice: "成功更新原材料：【#{@material.color}】"
    else
      render :edit
    end
  end

  def destroy
    if @material.destroy
      redirect_to materials_path, notice: "成功删除原材料：【#{@material.color}】"
    else
      redirect_to materials_path, alert: "无法删除原材料：【#{@material.color}】"
    end
  end

  def create
    @material = Material.new material_params

    if @material.save
      redirect_to materials_path, notice: "成功添加原材料：【#{@material.color}】"
    else
      render :new
    end
  end

  private
    def material_params
      params.require(:material).permit(:color, :price)
    end

    def set_material
      @material = Material.find params[:id]
    end
end
