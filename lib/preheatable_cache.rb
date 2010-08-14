module PreheatableCache
  NULL = 'preheatable_cache:null'

  def self.included(base)
    base.class_eval do
      def read_with_preheatable_cache(key, options=nil)
        if not @preheatable_cache
          return read_without_preheatable_cache(key, options)
        end

        locally_cached = @preheatable_cache[key]
        if locally_cached == NULL
          nil
        elsif locally_cached.nil?
          read_without_preheatable_cache(key, options)
        else
          # keep preheatable cached immutable
          locally_cached.duplicable? ? locally_cached.dup : locally_cached
        end
      end

      alias_method_chain :read, :preheatable_cache
    end
  end

  def preheat(keys)
    @preheatable_cache ||= {}

    data = if respond_to?(:read_multi)
      hash = read_multi(keys)
      # add keys for unfound values
      keys.each{|k| hash[k] = nil if hash[k].nil? }
      hash
    else
      keys.map{|key| read_without_preheatable_cache(key) }
    end

    keys.each do |key|
      value = data[key]
      @preheatable_cache[key] = if value.nil?
        NULL
      else
        value
      end
    end
  end

  def initialize(*args)
    super(*args)
    ActionDispatch::Callbacks.before proc{ clear_preheatable_cache }
  end

  def clear_preheatable_cache
    @preheatable_cache = nil
  end
end

# must be included in lowest classes, to overwrite reads
ActiveSupport::Cache::MemCacheStore.send(:include, PreheatableCache)