[![Build Status](https://travis-ci.org/mirakui/activerecord-mysql-sql-cache.svg)](https://travis-ci.org/mirakui/activerecord-mysql-sql-cache)

# activerecord-mysql-sql-cache

An ActiveRecord extension for enabling SQL\_CACHE and SQL\_NO\_CACHE in MySQL queries

## Dependencies

Supported versions:

- Ruby 1.9+
- ActiveRecord 4.0+ (Arel 4.0+)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-mysql-sql-cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-mysql-sql-cache

## Usage

Methods that `#sql_cache` and `#sql_no_cache` are added into `ActiveRecord::Relation`.

```ruby
class Product < ActiveRecord::Base
end

Product.where(id: 1).to_sql
# => SELECT `products`.`*` FROM `products` WHERE `id` = 1;

Product.where(id: 1).sql_cache.to_sql
# => SELECT SQL_CACHE `products`.`*` FROM `products` WHERE `id` = 1;

Product.where(id: 1).sql_no_cache.to_sql
# => SELECT SQL_NO_CACHE `products`.`*` FROM `products` WHERE `id` = 1;
```

`#sql_cache` accepts a boolean argument:

```ruby
# default: true
Product.where(id: 1).sql_cache(true).to_sql
# => SELECT SQL_CACHE `products`.`*` FROM `products` WHERE `id` = 1;

Product.where(id: 1).sql_cache(false).to_sql
# => SELECT SQL_NO_CACHE `products`.`*` FROM `products` WHERE `id` = 1;

Product.where(id: 1).sql_cache(nil).to_sql
# => SELECT `products`.`*` FROM `products` WHERE `id` = 1;
```

## License
Arproxy is released under the MIT license:

* www.opensource.org/licenses/MIT

Copyright (c) 2015 Issei Naruta
