require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'

class AppController < Sinatra::Base
  after do
    headers({ 'X-Frame-Options' => 'ALLOW-FROM http://londonlayout-line-status.herokuapp.com/',
  'Access-Control-Allow-Origin' => '*' })
  end
  get '/' do
    content_type :json
    data = Nokogiri.XML(open('http://cloud.tfl.gov.uk/TrackerNet/LineStatus'))
    results = {}
    data.css('LineStatus').each do |n|
      name = n.css('Line').attr('Name')
      description = n.attr('StatusDetails')
      status = n.css('Status').attr('Description')
      statusClass = n.css('Status').attr('CssStatus')
      results[name.split[0].downcase] = {description: description, status: status, class: statusClass}
    end
    results.to_json
  end

end