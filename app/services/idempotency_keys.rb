# Check and mark idempotency keys
module IdempotencyKeys
  KEY_STORE_TTL = 1.day

  def idempotency_key_ok?
    keys_store.set idempotency_key, 'wait', ex: KEY_STORE_TTL, nx: true
  end

  def get_total_by_key
    keys_store.get idempotency_key
  end

  def store_value_for_idempotency_key
    keys_store.setex(idempotency_key, KEY_STORE_TTL, @total)
  end

  def keys_store
    @keys_store ||= Redis.new
  end
end
