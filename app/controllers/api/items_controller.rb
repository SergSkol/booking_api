module Api
  class ItemsController < Api::ApplicationController
    def index
      items = Item.all
      render json: { items: }
    end

    def show
      @item = Item.where(id: params[:id]).includes(:reservations)
      render json: { item: @item.as_json(include: { reservations: { only: %i[start_date end_date] } }) }
    end

    def create
      if current_user.role != 'admin'
        render(json: { error: 'Only an admin can create an item' }, status: 401)
        return
      end

      item = Item.new(name: item_params[:name],
                      description: item_params[:description],
                      photo: item_params[:photo],
                      location: item_params[:location],
                      price: item_params[:price])

      if item.save
        render(json: { success: 'Item was created', item: { id: item.id } }, status: 200)
      else
        render(json: { error: item.errors.full_messages }, status: 422)
      end
    end

    def update
      if current_user.role != 'admin'
        render(json: { error: 'Only an admin can update an item' }, status: 401)
        return
      end

      item = Item.find(params[:id])

      if item.update(item_params)
        render(json: { success: 'Item was updated' }, status: :ok)
      else
        render(json: { error: item.errors.full_messages }, status: 422)
      end
    end

    def destroy
      if current_user.role != 'admin'
        render(json: { error: 'Only an admin can destroy an item' }, status: 401)
        return
      end

      item = Item.find(params[:id])
      if item.destroy!
        render(json: { success: 'Item was destroyed' }, status: :ok)
      else
        render(json: { error: item.errors.full_messages }, status: 422)
      end
    end

    def item_params
      params.permit(:name, :description, :photo, :location, :price)
    end
  end
end
