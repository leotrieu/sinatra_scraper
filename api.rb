require 'sinatra'
require "open-uri"
require "nokogiri"
require "json"

get '/' do
  'Hello world!'
end

get '/repos' do
  html = URI.open("https://github.com/search?q=Ruby%20Web%20Scraping")
  doc = Nokogiri::HTML(html)
  items_array = []

  doc.search(".repo-list li").each do |element|
    name = element.css('a.v-align-middle').text
    description = element.css('p.mb-1').text.strip
    repo = {
      name: name,
      description: description
    }  
    items_array << repo
  end
  
  JSON.pretty_generate(items_array)
end

get '/search_top30/:query' do

  url = "https://github.com/search?q=#{params['query']}"
  html = URI.open(url)
  doc = Nokogiri::HTML(html)
  items_array = []
    
  for page in 1..3
    html = URI.open(url+"&p=#{page}")
    doc = Nokogiri::HTML(html)

    doc.search(".repo-list li").each do |element|
      name = element.css('a.v-align-middle').text
      description = element.css('p.mb-1').text.strip
      repo = {
        name: name,
        description: description
      }  
      items_array << repo
    end

    sleep(2)
  end  
  
  JSON.pretty_generate(items_array)
end
