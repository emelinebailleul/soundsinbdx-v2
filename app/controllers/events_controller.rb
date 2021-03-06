class EventsController < ApplicationController
  before_action :set_event, only: [:show]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where("DATE(date) >= ?", Date.today)
  end

  # GET /events/archives
  # GET /events/archives.json
  def archives
    @events = Event.where("DATE(date) < ?", Date.today)
  end

  # GET /events/slug
  # GET /events/slug.json
  def show
  end

  # POST /events/slug
  def filters
     @events = Event.all

     # Location filter
     if params[:location] != 'all'
       @events = @events.joins(:location).where(locations: {
         name: params[:location]
       })
     end

     # Music type filter
     if params[:musicType] != 'all'
       @events = @events.joins(:music_type).where(music_types: {
         name: params[:musicType]
       })
     end

     # Price filter
     case params[:price]
     when '0'
       @events = @events.where(:price => 0)
     when '-10'
       @events = @events.where("PRICE <= 10 AND PRICE != 0")
     when '+10'
       @events = @events.where("PRICE > 10")
     end

     # Date filter
     case params[:date]
     when 'all'
       @events = @events.where("DATE(date) >= ?", Date.today)
     when 'today'
       @events = @events.where("DATE(date) = ?", Date.today)
     when 'tomorrow'
       @events = @events.where("DATE(date) = ?", Date.tomorrow)
     when 'this_week'
       @events = @events.where(
         "DATE(date) >= ? AND DATE(date) <= ?",
         Date.today.beginning_of_week,
         Date.today.end_of_week)
     when 'next_week'
       @events = @events.where(
         "DATE(date) >= ? AND DATE(date) <= ?",
         Date.today.next_week,
         Date.today.next_week.end_of_week)
     when 'this_month'
       @events = @events.where(
         "DATE(date) >= ? AND DATE(date) <= ?",
         Date.today.next_month.beginning_of_month,
         Date.today.next_month.end_of_month)
     end

     render 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.where(:slug => params[:slug]).first
    end

end
