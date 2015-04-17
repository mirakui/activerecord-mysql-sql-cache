require 'active_support/concern'

module ActiverecordMysqlSqlCache
  module Patches
    module Arel
      module Visitors
        module MySQL
          extend ActiveSupport::Concern

          included do
            alias_method_chain :visit_Arel_Nodes_SelectCore, :sql_cache
          end

          def visit_Arel_Nodes_SelectCore_with_sql_cache(o, collector)
            result = visit_Arel_Nodes_SelectCore_without_sql_cache(o, collector)
            if idx = result.value.index('DISTINCT')
              result.value.insert(idx + 1, o.mysql_sql_cache)
            else
              result.value.insert(1, o.mysql_sql_cache)
            end
            result
          end
        end
      end
    end
  end
end
