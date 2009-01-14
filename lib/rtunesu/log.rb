require 'time'

module RTunesU
  class Log
    def self.parse(log_text)
      self.new(log_text).parsed
    end
    
    def initialize(raw)
      @raw = raw
      @parsed = parse(@raw)
    end
    
    attr_reader :raw, :parsed
    
    module Errors
      class LogEntryParseError < RuntimeError; end
      class LogParseError < RuntimeError; end
    end
  
    private
    def parse_line(line)
      log, path = line.split('"')
      l = log.split << path
      entry = { :version => l[0],
                :site => l[1],
                :time => Time.parse("#{l[2]} #{l[3]}"),
                :action => l[4],
                :uuid => l[5],
                :user => l[6],
                :address => l[7],
                :agent => l[8],
                :path => l[9]
              }
      unless validate(entry)
        raise Errors::LogEntryParseError, "Failed to validate as an ItunesU log entry:\n#{line}"
      end    
      entry 
    end
    
    def parse(log)
      if not log.kind_of? IO and File.exists? log
        log = File.open(log) 
      elsif not log.respond_to? 'each_line'
        log = StringIO.new(log.to_s) 
      end
      begin
        log.map {|line| parse_line(line)}
      rescue Errors::LogEntryParseError => error
        raise Errors::LogParseError, "Failed to parse <#{log.class}>:\n#{error}"
      end
    end
    
    def validate(log_entry)
      if log_entry[:address].nil? or log_entry[:address].split(".").size != 4
        return false
      elsif log_entry[:agent].nil? or log_entry[:agent].split("/").size != 3
        return false
      elsif log_entry[:user].nil? or log_entry[:user].split("@").size != 2
        return false
      end
      
      return true
    end
  end
end