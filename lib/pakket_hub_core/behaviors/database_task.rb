require 'open3'
require 'benchmark'

module PakketHub::DatabaseTask

  DEFAULT_MAX_CONNECTIONS = 30

  def self.select_values(sql)
    ActiveRecord::Base.connection.select_values(sql)
  end

  def self.select_value(sql)
    select_values(sql).to_a.first
  end

  def self.select_id(sql)
    select_ids(sql).first
  end

  def self.select_ids(sql)
    rtn = ActiveRecord::Base.connection.select_values(sql)
    rtn.compact!
    rtn.map!(&:to_i)
    rtn.uniq!
    rtn
  end

  def self.select_id_set(sql)
    Set.new(select_ids(sql))
  end

  def self.select_all(sql)
    hashes = ActiveRecord::Base.connection.select_all(sql)
    return hashes unless hashes.is_a?(ActiveRecord::Result)
    hashes.rows.map do |row|
      Hash[*hashes.columns.zip(row).flatten]
    end
  end

  def self.execute(*sqls)
    sqls = sqls.flatten
    result_sets = []
    sqls.each do |sql|
      result_sets << ActiveRecord::Base.connection.execute(sql)
    end

    result_sets.each(&:clear)
    true
  end

  def self.update(sql)
    ActiveRecord::Base.connection.update(sql)
  end

  def self.insert(list, options = {})
    options = {validate: false, timestamps: false}.merge(options).with_indifferent_access
    grouped = list.group_by(&:class)
    batch_size = options[:batch_size] || 2000
    
    grouped.each_pair do |klass, relist|
      next unless klass < ActiveRecord::Base
      until relist.empty?
        klass.import(relist.pop(batch_size), validate: false, timestamps: false)
      end
    end
  end

  def select_values(sql)
    PakketHub::DatabaseTask.select_values(sql)
  end

  def select_value(sql)
    PakketHub::DatabaseTask.select_value(sql)
  end

  def select_id(sql)
    PakketHub::DatabaseTask.select_id(sql)
  end

  def select_ids(sql)
    PakketHub::DatabaseTask.select_ids(sql)
  end

  def select_id_set(sql)
    PakketHub::DatabaseTask.select_id_set(sql)
  end

  def select_all(sql)
    PakketHub::DatabaseTask.select_all(sql)
  end

  def execute(*sqls)
    PakketHub::DatabaseTask.execute(*sqls)
  end

  def update(sql)
    PakketHub::DatabaseTask.update(sql)
  end
  alias :update_records :update

  def insert_records(list, options = {})
    PakketHub::DatabaseTask.insert(list, options)
  end
  alias :insert_objects :insert_records

  def start_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def rollback
    if block_given?
      ActiveRecord::Base.transaction do
        yield
        raise ActiveRecord::Rollback
      end
    else
      raise ActiveRecord::Rollback
    end
  end

  def process(sql_array)
    Benchmark.realtime do
      total, terminate, completed, sql_queue =  sql_array.length, false, Queue.new, Queue.new
      sql_array.each {|sql| sql_queue << sql }
      threads = 1.upto(max_connections).map do
        Thread.new do
          until terminate || sql_queue.size == 0
            sql = sql_queue.pop
            command = "export PGPASSWORD=#{password};psql -h #{host} -d #{database} -U #{username} -c '#{sql}'"
            _, err, worker = Open3.capture3(command)
            if worker.to_i != 0
              terminate = true
              puts "failure: #{err}"
            else
              completed << nil
              puts "#{completed.size} of #{total} completed"
            end
          end
        end
      end

      threads.each(&:join)
      puts "Process ended"
    end
  end

  private

  def env
    @env || (defined?(Rails) ? Rails.env : "test")
  end

  def max_connections
    @max_connections || DEFAULT_MAX_CONNECTIONS
  end

  def configuration
    ActiveRecord::Base.configurations[env]
  end

  def host
    configuration['host']
  end

  def username
    configuration['username']
  end

  def database
    configuration['database']
  end

  def password
    configuration['password']
  end

end
