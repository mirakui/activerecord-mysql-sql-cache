patche_targets = %w[
  active_record/base
  active_record/relation
  arel/nodes/select_core
  arel/visitors/mysql
  arel/select_manager
]

ActiveSupport.on_load :active_record do
  patche_targets.each do |target|
    require target
    require_relative "./activerecord-mysql-sql-cache/patches/#{target}.rb"

    camelized_target = target.camelize
    camelized_target.gsub!('Mysql', 'MySQL')
    target_cls = camelized_target.constantize
    patch_mod = "ActiverecordMysqlSqlCache::Patches::#{camelized_target}".constantize
    target_cls.send :include, patch_mod
  end
end
