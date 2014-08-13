class HomeController < ApplicationController
  def index
  end

  def result
    return render json: {result: 0.0} if params["rs"].blank?

    materials = Material.all

    rs = params["rs"].inject(BigDecimal.new(0)) do |sum, value|
      material = materials.find { |m| m.id.to_s == value[1]["material"].to_s }
      material.nil? ? sum : sum + material.price * value[1]["rate"].to_f
    end

    render json: { result: rs }
  end
end
