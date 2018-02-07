require 'optparse'

class Parser
  def initialize(args)
    @args = args.dup
  end

  def parse
    params = OptionParser.new do |opts|
      opts.banner = 'Usage: ./demo.rb NAME'
    end.parse!(@args)
    find_in_params(params)
  end

  def find_in_params(params)
    return {} if params.empty?
    in_params = {}
    params.each do |param|
      #      require 'pry'; binding.pry
      param.include?('http://www.') ? in_params[:url] = param : in_params[:file] = param
    end
    in_params
  end
end
