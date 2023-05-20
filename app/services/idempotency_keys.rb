# Check and mark idempotency keys
module IdempotencyKeys
  KEY_STORE_TTL = 1.day

  def idempotency_key_ok?(key)
    return false if key.blank?
    return false if keys_store.get key

    true
  end

  def mark_idempotency_key(key)
    keys_store.setex(key, KEY_STORE_TTL, 1)
  end

  def keys_store
    @keys_store ||= Redis.new
  end
end
