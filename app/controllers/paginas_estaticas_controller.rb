class PaginasEstaticasController < ApplicationController
  def planos
    if params[:hash]
      log = LogHashEmailExpiracao.find_by_rand_hash(params[:hash])
      session[:cliente_id] = Cliente.find(log.cliente_id).id if log
  	else
  	  session[:cliente_id] = nil
    end
  end
end