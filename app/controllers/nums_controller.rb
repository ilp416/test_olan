# frozen_string_literal: true

class NumsController < ApplicationController
  def index
    @num = Num.create value: params[:val] if params[:val].present?

    status = @num.present? ? :created : :ok
    render plain: total_before(@num), status: status
  end

  private
  
  def total_before(current)
    scope = current.present? ? Num.where('id <= ?', current.id) : Num.all
    scope.sum(:value)
  end
end
