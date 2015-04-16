require 'mysql2'
require 'active_record'
require 'active_record/connection_adapters/mysql2_adapter'
require 'activerecord-mysql-sql-cache'

module Mysql2
  class Client
    def initialize(opts={})
      @query_options = @@default_query_options.dup.merge opts
    end
  end
end

ActiveRecord::ConnectionAdapters::Mysql2Adapter.class_eval do
  def quote_string(string)
    string
  end
  def configure_connection
  end
end

Arel::Visitors::ToSql.class_eval do
  def column_for o
    nil
  end
end

class Product < ActiveRecord::Base
  establish_connection 'mysql2://user@host/db'
end

describe 'ActiveRecord MySQL SQL_CACHE support' do
  context 'with AR::Relation' do
    let(:rel) { Product.limit(1) }

    it { expect(rel.to_sql).to                  be_sql_like("SELECT `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache(nil).to_sql).to   be_sql_like("SELECT `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache.to_sql).to        be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache(true).to_sql).to  be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache(false).to_sql).to be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_no_cache.to_sql).to     be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }

    it { expect(rel.sql_cache.count.to_sql).to  be_sql_like("SELECT SQL_CACHE COUNT(1) FROM `products`") }
    it { expect(rel.distinct.select(:name).sql_cache.to_sql).to
                                                be_sql_like("SELECT DISTINCT SQL_CACHE `products`.`name` FROM `products`") }
  end

  context 'with AR::Base' do
    it { expect(Product.sql_cache(nil).to_sql).to   be_sql_like("SELECT `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_cache.to_sql).to        be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_cache(true).to_sql).to  be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_cache(false).to_sql).to be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_no_cache.to_sql).to     be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }
  end
end
