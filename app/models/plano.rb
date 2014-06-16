class Plano < ActiveRecord::Base
	has_many :historicos
	has_one :cliente
end
