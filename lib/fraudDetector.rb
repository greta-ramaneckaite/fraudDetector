require 'date'

class FraudDetector
	attr_reader :postcode, :card_number, :card_expiry

	def initialise(postcode, card_number, card_expiry)
		@user = User.New(:address => "ABC 123", credit_card => "4111 1111 1111 1111")
		@address = Address.new(:user_id => "1", :postcode => 'ABC 123')
		@credit_card = Credit_card.new(:last_four_digits => "1111", :expiry_month => "06", :expiry_year => "2018")
	end

	def self.fraudulent?(postcode, card_number, expiry_date)
		# Separate booleans for each type of fraud
		postcode_bool = false
		card_number_bool = false
		card_expiry_bool = false

		# normalize add values
		norm_postcode = normalize_postcode(postcode)
		norm_card_number = normalize_card_number(card_number)
		norm_expiry_date = normalize_expiry_date(expiry_date)

		# Check postcode
		if @address.postcode.delete(' ') == norm_postcode #and @user.address.delete(' ') == user_postcode
			postcode_bool = true
		end

		# Check card_number
		if @credit_card.last_four_digits == norm_card_number[-4..-1] #and @user.credit_card[-4..-1] == norm_card_number[-4..-1]
			card_number_bool = true
		end

		# Check card_expiry
		db_date = Date.new(@credit_card.expiry_year, @credit_card.expiry_month)
		if norm_expiry_date == db_date
			card_expiry_bool = true
		end

		# Card fraudulence final check
		if card_number_bool == true or card_expiry_bool == true or postcode_bool == true
			return true
		else
      return false
		end
	end

	def self.normalize_postcode(postcode)
		postcode = postcode.delete(' ')
		return postcode
	end

	def self.normalize_card_number(card_number)
		card_number = card_number.delete(' ')
		return card_number
	end

	def self.normalize_expiry_date(expiry_date)
		date = expiry_date.split('/')
		exp_date = Date.new(2000 + date.last.to_i, date.first.to_i)
		return exp_date
	end
end

RSpec.describe FraudDetector do
  describe '.normalize_postcode' do
    context 'when the postcode contains spaces' do
      it 'removes the spaces' do
        expect(FraudDetector.normalize_postcode('ABC 123')).to eq 'ABC123'
      end
    end
  end

  describe '.normalize_card_number' do
    context 'when the card number contains spaces' do
      it 'removes the spaces' do
        expect(FraudDetector.normalize_card_number('4111 1111 1111 1111')).to eq '4111111111111111'
      end
    end
  end

  describe '.normalize_expiry_date' do
    context 'when the expiry date is written with a slash' do
      it 'creates date in standard format' do
        expect(FraudDetector.normalize_expiry_date('6/18')).to eq Date.parse('2018-06-01')
      end
    end
  end

  describe '.fraudulent?' do
    context 'when the postcode is incorrect' do
      it 'returns false to prove fraudulence' do
        expect(FraudDetector.fraudulent?('ABC 456', '4111 1111 1111 1111', '6/18')).to eq false
      end
    end
    # context 'when the card number is incorrect' do
    #   it 'returns false to prove fraudulence' do
    #     expect(FraudDetector.fraudulent?('ABC 123', '4111 1111 1111 2222', '6/18')).to eq false
    #   end
    # end
    # context 'when the expiry date is incorrect' do
    #   it 'returns false to prove fraudulence' do
    #     expect(FraudDetector.fraudulent?('ABC 123', '4111 1111 1111 1111', '8/20')).to eq false
    #   end
    # end
    # context 'when all information is correct' do
    #   it 'returns true to prove the user is valid' do
    #     expect(FraudDetector.fraudulent?('ABC 123', '4111 1111 1111 1111', '6/18')).to eq true
    #   end
    # end
  end
end
