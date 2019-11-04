class AddressesController < ApplicationController
  def new
    # @address = Address.new
  end

  def create
    user = current_user
    @address = current_user.addresses.create(address_params)
    if @address.save
      flash[:success] = 'A new address has been added to your profile!'
      redirect_to profile_path
    else
      flash.now[:error] = @address.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  private
    def address_params
      params.permit(:alias, :street, :city, :state, :zip)
    end
end
