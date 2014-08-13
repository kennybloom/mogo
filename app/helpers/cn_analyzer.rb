  # ==================================
	# cn_analyzer
	# ==================================
  def cn_analyzer(input)
  	en_words = ""
  	cn_words = ""
  	if input && input.size > 0 then
			input.scan(/[A-Za-z0-9]*/) {|s|
				en_words += " " + s unless s == nil || s.size == 0
			}
			
			input.scan(/[^A-Za-z0-9\.\,\?\!\-\,\'\"\[\]\(\)\£¬\¡£\£¿\£¡\¡¶\¡·\¡®\¡° \¡¢]*/) {|s|
				cn_words += " " + bigram(s) unless s == nil || s.size == 0	
			}			
		end

		words = en_words + cn_words
		words.upcase! unless words == nil || words.size == 0
		words = "" unless words != nil

		words
  end

	# ==================================
	# bigram
	# ==================================
	def bigram(input)
		words = ""
		last_s = ""
		input.scan(/./) {|s|
			if last_s.size > 0
				words = words + " " + last_s + s
			end
			last_s = s
		}

		words		
	end
