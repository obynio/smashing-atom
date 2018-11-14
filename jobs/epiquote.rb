require 'nokogiri'
require 'open-uri'

class Epiquote
    def latest_headlines()
        doc = Nokogiri::HTML(open("https://epiquote.fr/random"))
        quote_headlines = [];
        doc.xpath('//blockquote').each do |quote_item|
            if quote_item.xpath('p[2]').to_html.scan(/<br>/).length < 6
                quote_headline = EpiquoteBuilder.BuildFrom(quote_item)
                quote_headlines.push(quote_headline)
            end
        end
        quote_headlines
    end
end
  
class EpiquoteBuilder
    def self.BuildFrom(quote_item)
        {
            name: quote_item.xpath('p[1]/small/strong').text, 
            description: (quote_item.xpath('p[1]/small/em').text.length > 0) ? quote_item.xpath('p[1]/small/em').text : "No context", 
            quote: quote_item.xpath('p[2]').to_html, 
        }
    end
end
  
  @quotes = Epiquote.new()
  
SCHEDULER.every '15m', :first_in => 0 do |job|
    headlines = @quotes.latest_headlines
    send_event('epiquote', { :headlines => headlines})
end