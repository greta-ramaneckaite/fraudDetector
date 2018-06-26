require 'date'

class FraudDetector
	attr_reader :postcode, :card_number, :card_expiry

	def initialise(postcode, card_number, card_expiry)
		@user = User.New(:address => "S10 2FL", credit_card => "4111 1111 1111 1111")
		@address = Address.new(:user_id => "1", :postcode => "S10 2FL")
		@credit_card = Credit_card.new(:last_four_digits => "1111", :expiry_month => "06", :expiry_year => "2018")
	end

	def fraudulent?
		# Separate booleans for each check of fraud
		postcode_bool = false
		card_fraud_bool = false
		card_number_bool = false
		card_expiry_bool = false

		# Check postcode ( + manage spaces)
		user_postcode = postcode.delete(' ')
		if @address.postcode.delete(' ') == user_postcode #and @user.address.delete(' ') == user_postcode
			postcode_bool = true
		end

		# card_number check only last 4 digits
		cn = cn.delete(' ')
		cn = card_number[-4..-1]
		if @credit_card.last_four_digits == cn #and @user.credit_card[-4..-1] == cn
			card_number_bool = true
		end

		# card_expiry check correctly month and year match
		card_expiry_date = card_expiry.split('/')
		user_date = Date.new(card_expiry_date.first, card_expiry_date.last)
		db_date = Date.new(@credit_card.expiry_year, @credit_card.expiry_month)

		if user_date == db_date
			card_expiry_bool = true
		end

		# Card fraudulence
		if card_number_bool == true and card_expiry_bool == true
			card_fraud_bool = true
		end

		# Final check: if card and address frauds are both true
		if postcode_bool == true and card_fraud_bool == true
			return true
		else
			return false
		end		
	end
end