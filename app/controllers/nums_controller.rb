# frozen_string_literal: true

class NumsController < ApplicationController
  def index
    if params[:val].present? && params[:idempotency_key].present?
      @num = Num.create value: params[:val], idempotency_key: idempotency_key
    end

    render plain: current_total, status: status
  end

  private

  def status
    @num&.persisted? ? :created : :ok
  end
  
  def current_total
    scope = @num&.persisted? ? Num.where('id <= ?', @num.id) : Num.all
    scope.sum(:value)
  end

  def idempotency_key
    params[:idempotency_key]
  end
end
