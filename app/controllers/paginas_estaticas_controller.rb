class PaginasEstaticasController < ApplicationController
  def planos
    if params[:hash]
      log = LogHash.find_by_rand_hash(params[:hash])
      session[:cliente_id] = log.cliente_id if log
  	else
  	  session[:cliente_id] = nil
    end
  end
end