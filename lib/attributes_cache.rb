require 'attributes_cache/version'

require 'identity_cache'

module AttributesCache

  def self.included(base)
    base.send(:extend, ClassMethods)
  end
  
  module ClassMethods
    def fetch_attributes(*fetch_attributes)
      fetch_attributes.map(&:to_s).each do |attr|
        class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def fetch_#{attr}(expires_in: 30)
            @fetch_#{attr} ||= begin
              # 缓存访问量 30 秒钟，降低数据库命中率
              cache_backend = IdentityCache.cache.cache_fetcher.cache_backend
              cache_backend.fetch(cache_key + "/#{attr}", expires_in: expires_in) do
                result = self.class.connection.execute("select #{attr} from " + self.class.model_name.plural + " where id = '" + id.to_s + "'").first
                result ? result["#{attr}"] : 0
              end
            end
          end
        METHOD
      end
    end
  end
end





