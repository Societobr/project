class ContatosController < ApplicationController

	def new
    @contato = Contato.new
  end

  def create
    @contato = Contato.new(contato_params)

    if @contato.valid?
      ContactMailer.mensagem_contato(@contato).deliver
      flash[:success] = 'Sua mensagem foi recebida com sucesso. Obrigado!'
  	else
  		flash[:error] = "<strong>Não foi possível enviar sua mensagem.</strong>#{lista_de_erros}"
    end
    redirect_to :action => 'new'
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contato_params
      params.require(:contato).permit(:nome, :email, :assunto, :mensagem)
    end

    def lista_de_erros
      erros = ""
      @contato.errors.full_messages.each do |erro|
        erros = "#{erros}\n- #{erro}"
      end
      return erros
    end
end