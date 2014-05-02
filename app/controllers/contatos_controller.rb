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
  		flash[:error] = 'Não foi possível enviar sua mensagem.'
    end
    redirect_to :action => 'new'
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contato_params
      params.require(:contato).permit(:nome, :email, :assunto, :mensagem)
    end
end