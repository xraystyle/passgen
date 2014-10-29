#!/usr/bin/ruby -w

# system 'clear'

@opts = {digits: false, symbols: false}

@letters = ('a'..'z').to_a + ('A'..'Z').to_a 
@digits = (0..9).to_a  
@symbols = '~!@#$%^&*()_+{}|[]\;:,./<>?'.split("")

@usage = "\nUsage: passgen [options]\nOptions:\n\t-l : total length of password (REQUIRED)\n\t-d : number of digits desired (default: 0)\n\t-s : number of symbols desired (default: 0)\n\n"


# valid command line arguments: -l, -d, -s, -h. -l is required, unless -h is found.

# process the command line args before anything else.

def error_and_exit(message=nil)
	puts 
	puts message if message
	puts @usage
	exit!
end


while ARGV.any?


	option = ARGV.shift

	case option
	when "-l"
		@length = ARGV.shift
	when "-d"
		@opts[:digits] = ARGV.shift
	when "-s"
		@opts[:symbols] = ARGV.shift
	when "-h", "--help"
			error_and_exit
	else
		error_and_exit("Unknown option: #{option}")
	end
	
end


# length is required
unless defined?(@length) 
	error_and_exit("Password length is required.")
end


# Check if a string is just digits or not.
def is_number?(x)
	if /[^0-9]/.match(x)
		false
	else
		true
	end
	
end


# Check the passed args for syntax errors
def idiot_check 

	unless is_number?(@length)
		error_and_exit("Invalid value: -l #{@length}")
	end
	
	if @opts[:digits]
		error_and_exit("Invalid value: -d #{@opts[:digits]}") unless is_number?(@opts[:digits])
		error_and_exit("Digits (#{@opts[:digits]}) can't be greater than total length (#{@length}).") unless @length.to_i >= @opts[:digits].to_i
		digits = true
	end

	if @opts[:symbols]
		error_and_exit("Invalid value: -s #{@opts[:symbols]}") unless is_number?(@opts[:symbols])
		error_and_exit("Symbols (#{@opts[:symbols]}) can't be greater than total length (#{@length}).") unless @length.to_i >= @opts[:symbols].to_i
		symbols = true
	end

	if digits && symbols
		error_and_exit("Digits (#{@opts[:digits]}) plus symbols (#{@opts[:symbols]}) can't be greater than total length (#{@length}).") unless @length.to_i >= @opts[:symbols].to_i + @opts[:digits].to_i
	end

	@length = @length.to_i
	digits ? @opts[:digits] = @opts[:digits].to_i : @opts[:digits] = 0
	symbols ? @opts[:symbols] = @opts[:symbols].to_i : @opts[:symbols] = 0

end


# Make the password, with the specified length, and number of digits and symbols.
def make_pass(l, options = {})

	pass_chars = []

	(l - (options[:digits] + options[:symbols])).times do

		pass_chars << @letters.sample

	end

	options[:digits].times do
		
		pass_chars << @digits.sample

	end

	options[:symbols].times do
		
		pass_chars << @symbols.sample

	end

	pass_chars.shuffle.join

end

idiot_check

puts
puts make_pass(@length, @opts)
puts
exit 0