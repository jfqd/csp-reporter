# encoding: UTF-8
require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'yaml'
require 'dotenv'
require 'erb'
require 'uri'

Dotenv.load ".env.#{ENV["RACK_ENV"] || "production"}", '.env'

set :database, Hash.new.tap { |hash|
  YAML::load( File.open('config/database.yml') ).each do |key, value|
    renderer = ERB.new(value)
    hash[key.to_sym] = renderer.result()
  end
}

configure do
  # http://recipes.sinatrarb.com/p/middleware/rack_commonlogger
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

class CspReport < ActiveRecord::Base
end

class String
  def blank?
    self == nil || self == ''
  end
end

post '/' do
  begin
    ActiveRecord::Base.clear_active_connections!
    report_base = JSON.parse(request.body.read)
    if report_base.has_key? 'csp-report'
      report = report_base['csp-report']
      domain = URI.parse(report['document-uri'].to_s.downcase).host.sub(/\Awww\./,'') rescue ''
      CspReport.create(
        domain:              domain,
        blocked_uri:         report['blocked-uri'].to_s.downcase,
        disposition:         report['disposition'].to_s.downcase,
        document_uri:        report['document-uri'],
        effective_directive: report['effective-directive'].to_s.downcase,
        violated_directive:  report['violated-directive'].to_s.downcase,
        referrer:            report['referrer'].to_s.downcase,
        status_code:         (report['status-code'] || 0).to_i,
        raw_report:          report,
        raw_browser:         headers['User-Agent']
      )
    end
    status 200
  rescue Exception => e
    logger.warn "[csp-reports] Rescue: #{e.message}"
    halt 400
  end
end

get "/*" do
  halt 403
end