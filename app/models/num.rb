# frozen_string_literal: true

class Num < ApplicationRecord
  validates :idempotency_key, uniqueness: true
end
