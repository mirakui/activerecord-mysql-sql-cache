module ActiverecordMysqlSqlCache
  module Patches
    module Arel
      module SelectManager
        def mysql_sql_cache=(value)
          @ctx.mysql_sql_cache = value
        end

        def mysql_sql_cache
          @ctx.mysql_sql_cache
        end
      end
    end
  end
end
