# frozen_string_literal: true

class NumsController < ApplicationController
  include IdempotencyKeys

  def index
    if idempotency_key_ok? && params[:val].present?
      Num.transaction(requires_new: true) do
        @num = Num.create value: params[:val]
        raise ActiveRecord::Rollback unless idempotency_key_ok?
        mark_idempotency_key idempotency_key
      end
    end

    render plain: current_total, status: status
  end

  private

  def status
    @num.present? ? :created : :ok
  end
  
  def current_total
    scope = @num.present? ? Num.where('id <= ?', @num.id) : Num.all
    scope.sum(:value)
  end

  def idempotency_key
    params[:idempotency_key]
  end

  def idempotency_key_ok?
    super idempotency_key
  end
end
