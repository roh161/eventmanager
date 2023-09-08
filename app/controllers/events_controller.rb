class EventsController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :set_event, only: [:edit, :update, :destroy, :show]
  
    def index
      search_query = params[:q]
      if search_query.present?
        @events = Event.where("name LIKE ? OR city LIKE ? OR user_id IN (SELECT id FROM users WHERE full_name LIKE ? OR email LIKE ?)",
                          "%#{search_query}%", "%#{search_query}%", "%#{search_query}%", "%#{search_query}%")

      else
        @events = Event.all
      end
    
      if params[:q].present?
        query = "%#{params[:q]}%"
        @event_names = Event.where("name LIKE ?", query).pluck(:name)
        @event_cities = Event.where("city LIKE ?", query).pluck(:city)
      end
    
      respond_to do |format|
        format.html
        format.json { render json: { event_names: @event_names, event_cities: @event_cities } }
      end
    end
          
    def new
      @event = Event.new
    end
  
    def create
      @event = current_user.events.build(event_params)
      if @event.save
        # Enqueue the reminder job to be performed after 2 minutes
        EventReminderJob.set(wait: 2.minutes).perform_later(@event.id, current_user.id)
        redirect_to my_events_events_path, notice: "Event created successfully."
      else
        render :new
      end
    end

    def edit
    end

    def show
    end

    def my_events
        @events = current_user.events
    end
    
    def update
      if @event.update(event_params)
        redirect_to event_path, notice: "Event updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @event.destroy
      redirect_to my_events_events_path, notice: "Event deleted successfully."
    end
        
    private
  
    def set_event
      @event = Event.find(params[:id])
    end
  
    def event_params
      params.require(:event).permit(:name, :description, :start_date, :end_date, :city)
    end
  end
  