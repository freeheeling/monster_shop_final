class AddressesController < ApplicationController
  def new
    # @address = Address.new
  end

  def create
    user = current_user
    address = current_user.addresses.create(address_params)
    if address.save
      flash[:success] = 'A new address has been added to your profile!'
      redirect_to profile_path
    else
      flash.now[:error] = address.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    address = Address.find(params[:id])
    address.update(address_params)
    if address.save
      flash[:success] = 'Your address has been updated!'
      redirect_to profile_path
    else
      flash.now[:error] = address.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to profile_path
  end

  private
    def address_params
      params.permit(:alias, :street, :city, :state, :zip)
    end
end
