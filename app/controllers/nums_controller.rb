# frozen_string_literal: true

class NumsController < ApplicationController
  include IdempotencyKeys

  def index
    if params[:val].present? && idempotency_key.present?
      store_data if idempotency_key_ok?
      @total ||= get_total_by_key
    end

    render plain: @total || Num.all.sum(:value),
           status: status
  end

  private

  def store_data
    @num = Num.create value: params[:val]
    @total = Num.where('id <= ?', @num.id).sum(:value)
    store_value_for_idempotency_key
  end

  def status
    @num.present? ? :created : :ok
  end
  
  def idempotency_key
    params[:idempotency_key]
  end
end
