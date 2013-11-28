require "logger"

ActiveRecord::Base.configurations = YAML.load_file('db/database.yml')
ActiveRecord::Base.establish_connection(:development)

ActiveRecord::Base.logger = Logger.new($stderr)
