module ApiHelper
  def transform_keys_to_camelcase(hash)
    new_hash = {}
    
    hash.each do |key, value|
      new_hash[key.to_s.camelize(:lower)] = value
    end
    new_hash
  end
end
