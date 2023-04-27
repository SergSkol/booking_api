module Api
  class ReservationsController < Api::ApplicationController
    def index
      @reservations = current_user.reservations.includes(:item, :user)
      render json: { reservations: @reservations.as_json(include: { item: {}, user: {} }) }
    end

    def show
      reservation = Reservation.find(params[:id])

      if current_user.role != 'admin' && current_user.id != reservation.user_id
        render(json: { error: 'Only an admin or owner can show a reservation' }, status: 401)
        return
      end

      render json: { reservation: }
    end

    def create
      reservation = Reservation.new(start_date: reservation_params[:start_date],
                                    end_date: reservation_params[:end_date],
                                    item_id: reservation_params[:item_id],
                                    user_id: current_user.id)

      if reservation.save
        render(json: { success: 'Reservation was created', item: { id: reservation.id } }, status: 200)
      else
        render(json: { error: reservation.errors.full_messages }, status: 422)
      end
    end

    def update
      reservation = Reservation.find(params[:id])
      if current_user.role != 'admin' && current_user.id != reservation.user_id
        render(json: { error: 'Only an admin or owner can update a reservation' }, status: 401)
        return
      end

      if reservation.update(reservation_params)
        render(json: { success: 'Reservation was updated' }, status: :ok)
      else
        render(json: { error: reservation.errors.full_messages }, status: 422)
      end
    end

    def destroy
      reservation = Reservation.find(params[:id])

      if current_user.role != 'admin' && current_user.id != reservation.user_id
        render(json: { error: 'Only an admin or owner can destroy a reservation' }, status: 401)
        return
      end

      if reservation.destroy!
        render(json: { success: 'Reservation was destroyed' }, status: :ok)
      else
        render(json: { error: reservation.errors.full_messages }, status: 422)
      end
    end

    def reservation_params
      params.permit(:start_date, :end_date, :item_id)
    end
  end
end
