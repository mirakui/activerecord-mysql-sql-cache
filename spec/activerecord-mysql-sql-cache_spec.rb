require 'active_record'
require 'activerecord-mysql-sql-cache'

def initialize_database
  db_url = ENV['DATABASE_URL'] || 'mysql2://root@0.0.0.0/ar_test'
  ActiveRecord::Base.establish_connection db_url
  con = ActiveRecord::Base.connection

  con.execute 'DROP TABLE IF EXISTS products'
  con.execute <<-DDL
CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  user_id INT
)
  DDL
  con.execute 'DROP TABLE IF EXISTS users'
  con.execute <<-DDL
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL
)
  DDL

  alice = User.create name: 'alice'
  Product.new name: 'chocolate', user: alice
  Product.new name: 'cookie', user: alice
end

class Product < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :products
end

describe 'ActiveRecord MySQL SQL_CACHE support' do
  before(:all) do
    initialize_database
  end

  context 'with AR::Relation' do
    let(:rel) { Product.limit(1) }

    it { expect(rel.to_sql).to                  be_sql_like("SELECT `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache(nil).to_sql).to   be_sql_like("SELECT `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache.to_sql).to        be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache(true).to_sql).to  be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_cache(false).to_sql).to be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(rel.sql_no_cache.to_sql).to     be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }

    it { expect(rel.distinct.select(:name).sql_cache.to_sql
               ).to be_sql_like("SELECT DISTINCT SQL_CACHE `products`.`name` FROM `products` LIMIT 1") }
    it do
      rel.sql_cache.count
      expect(ActiveRecord::Base.connection).to have_receive(:execute).with("SELECT SQL_CACHE COUNT(*) FROM `products`")
    end
  end

  context 'with AR::Base' do
    it { expect(Product.sql_cache(nil).limit(1).to_sql).to   be_sql_like("SELECT `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_cache.limit(1).to_sql).to        be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_cache(true).limit(1).to_sql).to  be_sql_like("SELECT SQL_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_cache(false).limit(1).to_sql).to be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }
    it { expect(Product.sql_no_cache.limit(1).to_sql).to     be_sql_like("SELECT SQL_NO_CACHE `products`.* FROM `products` LIMIT 1") }
  end
end
