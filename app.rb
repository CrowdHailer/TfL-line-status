require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'

class AppController < Sinatra::Base
  after do
    headers({ 'Access-Control-Allow-Origin' => '*' })
  end
  get '/' do
    content_type :json
    data = Nokogiri.XML(open('http://cloud.tfl.gov.uk/TrackerNet/LineStatus'))
    results = {}
    data.css('LineStatus').each do |n|
      name = n.css('Line').attr('Name')
      description = n.attr('StatusDetails')
      status = n.css('Status').attr('Description')
      results[name] = {description: description, status: status}
    end
    results.to_json
  end

end