require 'open-uri'
require 'iniparse'
require 'timeout'

module Helpers
  class Apps

    def self.app_current_version(srv, app_name)
      url = app_url_version(srv, app_name)

      contents = nil

      x = ''
      open(url){|f| x=f.meta  }
      contents = open(url, read_timeout: 10).read

      return nil if contents.nil?

      doc = (IniParse.parse(contents)rescue nil)
      return nil if doc.nil?
      v = (doc['__anonymous__']['version'] rescue nil)

      v
    end


    def self.app_url_version(srv, app_name)
      "#{srv['server_app_repo_versions']}/#{app_name}-version.txt"
    end


  end
end