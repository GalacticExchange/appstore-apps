module APP_DB

  def self.connect
    ActiveRecord::Base.establish_connection(
        adapter:  'mysql2',
        host:     $settings['db']['host'],
        database: $settings['db']['database'],
        username: $settings['db']['username'],
        password: $settings['db']['password']
    )
  end


  def self.test
    c = connect

    p c.inspect

  end

end