require 'active_support/concern'

module ActiverecordMysqlSqlCache
  module Patches
    module ActiveRecord
      module Relation
        extend ActiveSupport::Concern

        def mysql_sql_cache_value=(value)
          @values[:mysql_sql_cache] = value
        end

        def mysql_sql_cache_value
          @values[:mysql_sql_cache]
        end

        def sql_cache(enabled=true)
          if enabled.nil?
            self.mysql_sql_cache_value = nil
          else
            self.mysql_sql_cache_value = enabled ? ' SQL_CACHE ' : ' SQL_NO_CACHE '
          end
          self
        end

        def sql_no_cache
          sql_cache(false)
        end

        included do
          def build_arel_with_sql_cache
            build_arel_without_sql_cache.tap do |arel|
              arel.mysql_sql_cache = self.mysql_sql_cache_value
            end
          end
          alias_method_chain :build_arel, :sql_cache
        end
      end
    end
  end
end

