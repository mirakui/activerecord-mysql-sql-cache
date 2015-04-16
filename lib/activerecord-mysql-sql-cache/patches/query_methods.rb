module ActiverecordMysqlSqlCache
  module Patches
    module QueryMethods
      def sql_cache(enabled=true)
        if enabled.nil?
          arel.mysql_sql_cache = nil
        else
          arel.mysql_sql_cache = enabled ? 'SQL_CACHE' : 'SQL_NO_CACHE'
        end
        self
      end

      def sql_no_cache
        sql_cache(false)
      end
    end
  end
end
