class TransactionsController < ApplicationController
  def index
    @transactions = Transactions.all
  end

  def import
    Transactions.arrest_illegal_characters(params[:file])
    redirect_to transactions_url, notice: "Products imported."
  end
end
