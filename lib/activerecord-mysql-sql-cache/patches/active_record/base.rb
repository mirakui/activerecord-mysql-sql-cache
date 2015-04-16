module ActiverecordMysqlSqlCache
  module Patches
    module ActiveRecord
      module Base
        extend ActiveSupport::Concern

        included do
          def self.sql_cache(enabled=true)
            all.sql_cache(enabled)
          end

          def self.sql_no_cache
            sql_cache(false)
          end
        end
      end
    end
  end
end

