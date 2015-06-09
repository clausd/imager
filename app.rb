require 'sinatra'
require 'json'
require 'digest'
require 'base64'

post '/img/' do
  if params[:uri]
    raw = params[:uri]
    bits = Base64.decode64(raw[22..-1])
    digest = Base64.encode64(Digest::SHA256.digest(bits)).chomp.gsub(/[^a-zA-Z0-9]/,'')
    filename = digest + '.png'
    File.open(File.dirname(__FILE__) + '/public/cache/' + filename, 'w') do |f|
      f.write(bits)
    end
    # Set cross origin header if you need it
    # Next line allows use from anywhere
    # response.headers['Access-Control-Allow-Origin'] = '*'
    content_type :json
    { :url => request.url.gsub(/img.?$/, '') + 'cache/' + filename}.to_json
  end
end
