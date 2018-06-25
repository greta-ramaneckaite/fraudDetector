require 'FraudDetector'

describe FraudDetector do 
	context "test" do
		it "gets the db" do
			fraudDetector = FraudDetector.new

			expect(@user).exist

		end
	end
end