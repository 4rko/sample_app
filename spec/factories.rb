FactoryGirl.define do
	factory :user do
		sequence(:name)  { |n| "Osoba #{n}" }
		sequence(:email) { |n| "osoba_#{n}@przyklad.pl" }
		password "kopytko"
		password_confirmation "kopytko"

		factory :admin do
			admin true
		end
	end

	# factory :user do
	# 	name					"Pan Sting"
	# 	email					"sting@mail.co.uk"
	# 	password				"DesertRose"
	# 	password_confirmation 	"DesertRose"
	# end

	# factory :bacha do
	# 	name					"Bacha"
	# 	email					"bacha@bacha.pl"
	# 	password 				"haslobachy"
	# 	password_confirmation	"haslobachy"
	# end

	# factory :hanka do
	# 	name 					"Hanka"
	# 	email					"hanka@hanka.pl"
	# 	password 				"haslohanki"
	# 	password_confirmation	"haslohanki"
	# end
end