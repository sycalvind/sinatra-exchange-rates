require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "dotenv/load"

key = ENV.fetch("EXCHANGE_RATE_KEY")
currencies_url = "https://api.exchangerate.host/list?access_key=#{key}"
currencies_data = (HTTP.get(currencies_url)).to_s
parsed_currencies = JSON.parse(currencies_data)
ccy_list = parsed_currencies["currencies"].keys - ["BOB"]

get("/") do
  @currencies_list = ccy_list
  erb(:home)
end

get("/:currency") do
  @exchange_from = params.fetch("currency")
  @currencies_list = ccy_list
  erb(:convert_ccy)
end

get("/:from/:to") do
  @from = params.fetch("from")
  @to = params.fetch("to")
  conversion_url = "https://api.exchangerate.host/convert?from=#{@from}&to=#{@to}&amount=1&access_key=#{key}"
  conversion_data = HTTP.get(conversion_url).to_s
  parsed_conversion = JSON.parse(conversion_data)
  @result = parsed_conversion["result"]
  erb(:converted)
end
