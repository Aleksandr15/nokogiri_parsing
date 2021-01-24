require 'open-uri'
require 'nokogiri'
require 'json'
require 'date'

doc = Nokogiri::HTML(URI.open('https://cubecinema.com/programme/'))
showings = []
doc.css('.showing').each do |showing|
  showing_id = showing['id'].split('_').last.to_i
  tags = showing.css('.tags a').map{|tag| tag.text.strip}
  title_el = showing.at_css('h3').children.each{|c| c.remove if c.name == 'span'}
  title = title_el.text.strip
  dates = showing.at_css('.start_and_pricing').inner_html.strip
  dates = dates.split('<br>').map(&:strip).map{ |d| DateTime.parse(d) }
  description = showing.at_css('.copy').text.gsub('[more]','').strip
  showings.push(
    id: showing_id,
    title: title,
    tags: tags,
    dates: dates,
    description: description
  )
end

puts JSON.pretty_generate(showings)
