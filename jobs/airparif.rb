require 'mini_magick'

SCHEDULER.every '1h', first_in: 0 do
  image = MiniMagick::Image.open('https://www.airparif.asso.fr/services/cartes/indice/date/jour')

  # Remove text indicating the current day
  image.combine_options do |c|
    c.fill 'white'
    c.draw 'rectangle 300,0 500,40'
  end

  # Remove Airparif logo
  image.combine_options do |c|
    c.fill 'white'
    c.draw 'rectangle 320,276 440,345'
  end

  # make transparent background
  image.combine_options do |c|
    c.fill 'none'
    c.draw 'color 0,0 floodfill'
  end

  # Crop the unnecessary sides
  image.crop '405x323+6+20'

  data = fetch_data('https://www.airparif.asso.fr/appli/api/1.1/indice')
  jour = data[1]['indice']
  demain = data[2]['indice']

  send_event('airparif',
             image: 'data:image/png;base64,' + Base64.encode64(image.to_blob),
             jour: jour,
             demain: demain)
end

def fetch_data(path)
  response = Net::HTTP.get_response(URI(path))
  JSON.parse(response.body)
end