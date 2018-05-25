class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  before_action :check_key

  def check_key
    if params[:key] && params[:key] == 'istosElid@s!'
    else
      json_response({ message: 'Bad request.' }, :unprocessable_entity)
    end
  end
end
