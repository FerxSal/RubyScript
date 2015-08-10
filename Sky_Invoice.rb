#Must consume bill JSON from endpoint:
#http://safe-plains-5453.herokuapp.com/bill.json
require 'open-uri'
require 'json'
require 'pp'
require 'erb'



request_uri = 'http://safe-plains-5453.herokuapp.com/bill.json'
request_query = ''
url = "#{request_uri}#{request_query}"

# Actually fetch the contents of the remote URL as a String.
buffer = open(url).read
res = JSON.parse(buffer)


#parsing the string from Json
def toString(h)
  h.each_pair do |k,v|
   if v.is_a?(Hash)
    puts "key: #{k} recursing..."
    toString(v)
   else
     puts "key: #{k} value: #{v}"
   end
  end
end

puts toString(res)     

#puts content_endpoint(result)
def generate_invoice(res)

erb_file = 'invoice.html.erb'
html_file = File.basename(erb_file, '.erb') 


 @generated = res["statement"]["generated"]
 @due = res["statement"]["due"]
 @from = res["statement"]["period"]["from"]
 @to = res["statement"]["period"]["to"]
 
 @package_header = res["package"]["subscriptions"] 
 @total_package_value = res["package"]["total"]
 
 @call_charges = res["callCharges"]["calls"] 
 
 @total_call_charge = res["callCharges"]["total"]
 
 @sky_store_rentals = res["skyStore"]["rentals"]
 
 @sky_store_buykeep = res["skyStore"]["buyAndKeep"]
 
 @sky_store_total = res["skyStore"]["total"]
 
 @total_val = res["total"]
 
 erb_str = File.read(erb_file)
 renderer = ERB.new(erb_str)
 result = renderer.result()

 File.open(html_file, 'w') do |f|
  f.write(result)
 end

end

puts generate_invoice(res)