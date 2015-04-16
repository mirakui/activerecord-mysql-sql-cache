module ActiverecordMysqlSqlCache
  module Patches
    module Arel
      module Nodes
        module SelectCore
          attr_accessor :mysql_sql_cache
        end
      end
    end
  end
end
