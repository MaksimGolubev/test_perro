require_relative '../lib/parsing'
require 'json'
require 'csv'

params = Parser.new(ARGV).parse
if params.size == 2
  p params
else
  p 'error in params'
end
parse_web = WebParser.new
result = parse_web.parser_petsonic(params[:url])
csv_name = params[:file]
# result =  JSON.parse(File.read('temp.json'))
arr_end = []
#      require 'pry'; binding.pry
result.each_value do |val|
  part3 = val["img"]
  val["atr"].each do |atr|
    part1 = atr.first
    part2 = atr.last
    arr_end << [part1, part2, part3]
  end
end
csv = CSV.generate do |c|
  arr_end.each { |e| c << e }
end
File.open("#{csv_name}.csv", 'w') { |f| f << csv }
p 'end'
