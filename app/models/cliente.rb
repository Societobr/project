class Cliente < ActiveRecord::Base
  has_many :atividades
  has_many :users, through: :atividades
  has_many :historicos
  has_many :status_transacao_pag_seguros, through: :historicos
  has_many :log_email_expiracaos
  has_many :log_hash_email_amigos
  
  belongs_to :plano
  belongs_to :amigo, class_name: "Cliente", foreign_key: "cliente_id"
  
  before_save :set_registro

  scope :expirados, -> { where('expira_em <= ?', Date.current) }
  scope :ativos, -> { where('expira_em > ?', Date.current) }
  scope :aguard_pag, -> { where('expira_em is NULL', Date.current) }

  usar_como_cpf :cpf
  validate :cpf_unico
  validates_uniqueness_of :email, message: "já cadastrado em nossa base de dados."
  validates_presence_of :nome,
    :ddd,
	:telefone,
	:email,
	:cpf,
	:nascimento,
	:cep,
	:cidade,
	:estado,
	:bairro,
	:rua,
	:numero, message: 'deve ser preenchido'

  def cpf_unico
    if self.cpf and !self.cpf.to_s.empty? and Cliente.where(cpf: self.cpf).where('id <> ?', self.id || 0).first
      errors.add(:cpf, "já está cadastrado em nossa base de dados.")
    end
  end

  def self.to_csv
  	CSV.generate do |csv|
        csv << column_names
  	    all.each do |cliente|
  		  csv << cliente.attributes.values_at(*column_names)
  		end
  	end
  end

  def ativo?
    true if self.expira_em >= Date.current
  end

  def aguard_pag?
    true if self.expira_em.nil?
  end

  def expirado?
    true if self.expira_em && self.expira_em < Date.current
  end

  def status_plano
    return 'ativo' if self.expira_em > Date.current
    return 'aguardando pagamento' if self.expira_em.nil?
    return 'expirado' if self.expira_em <= Date.current
  end

  def set_registro
    last_id = Cliente.last.id || 0
  	self.registro = '#' + Date.current.strftime("%y%m%d") + last_id.next.to_s.rjust(4,"0")
  end

end
