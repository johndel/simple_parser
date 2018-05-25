class V1::DomainsController < ApplicationController

  def index
    @domains = Domain.page(params[:page]).per(10)
    json_response(@domains)
  end

  def create
    code = RestClient.get(params[:url]).code rescue "404"
    if code.to_s == "200"
      @domain = Domain.where(url: params[:url]).first_or_create
      ParseDomainJob.perform_later(@domain.id)
      json_response(@domain, :created)
    else
      render json: {message: 'error'}, status: status
    end
  end

  def show
    @domain = Domain.find(params[:id])
    @domain_serializer = DomainSerializer.new(@domain).serializable_hash
    render json: @domain_serializer, status: :ok
    #json_response(@domain_serializer)
  end

  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy
    head :no_content
  end

  def parse
    ParseDomainJob.perform_later(params[:id])
  end
end
