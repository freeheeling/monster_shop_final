# frozen_string_literal: true

class OrdersController < ApplicationController
  def new; end

  def show
    @order = Order.find(params[:id])
  end

  def create
    if current_user.address?
      order = current_user.orders.create(address_id: params[:address_id])
      if order.save
        cart.items.each do |item, quantity|
          order.item_orders.create(
            item: item,
            quantity: quantity,
            price: item.price,
            merchant_id: item.merchant_id
          )
        end
        session.delete(:cart)
        redirect_to "/orders/#{order.id}"
      else
        flash[:notice] = 'Please complete address form to create an order.'
        render :new
      end
    else
      flash[:error] = 'An address is required to checkout.'
      redirect_to '/profile/addresses/new'
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
