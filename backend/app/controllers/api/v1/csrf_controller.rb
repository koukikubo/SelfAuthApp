class Api::V1::CsrfController < ApplicationController
  def show
    render json: { csrf_token: form_authenticity_token }
  end
end