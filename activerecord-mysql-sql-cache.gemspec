# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-mysql-sql-cache/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-mysql-sql-cache"
  spec.version       = ActiverecordMysqlSqlCache::VERSION
  spec.authors       = ["Issei Naruta"]
  spec.email         = ["naruta@cookpad.com"]
  spec.summary       = %q{An ActiveRecord extension for enabling SQL_CACHE and SQL_NO_CACHE in MySQL queries}
  spec.homepage      = "https://github.com/mirakui/activerecord-mysql-sql-cache"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 4.0"
  spec.add_dependency "arel", ">= 4.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "arproxy"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mysql2"
end
