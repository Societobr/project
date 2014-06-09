class User < ActiveRecord::Base
	has_many :atividades
	has_many :clientes, through: :atividades
	belongs_to :role

	has_secure_password

	validates_uniqueness_of :username
end
