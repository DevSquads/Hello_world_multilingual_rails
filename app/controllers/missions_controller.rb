# frozen_string_literal: true

class MissionsController < ApplicationController
  before_action :set_mission, only: %i[show edit update destroy]

  # GET /missions
  # GET /missions.json
  # retrieves all missions and all their translations
  def index
    @missions = Mission.all
    all_missions_in_all_languages = []
    locale_translation_tables = I18n.backend.send(:translations)

    # loop through all missions and then loop through all languages
    @missions.each do |mission_to_match|
      current_mission_key = mission_id_to_locale_id mission_to_match.id

      locale_translation_tables.each do |current_language_table|
        current_language = current_language_table[0]
        missions_for_language = current_language_table[1][:missions]

        if mission_supports_language(missions_for_language, current_mission_key)
          all_missions_in_all_languages.push(get_language_specific_mission(
                                                 mission_to_match,
                                                 missions_for_language[current_mission_key.to_sym],
                                                 current_language
                                             ))
        end
      end
    end
    # make visible to view
    @missions = all_missions_in_all_languages
  end

  def by_lang
    @missions = Mission.all
    local_translation_tables = I18n.backend.send(:translations)[I18n.locale]
    all_missions = local_translation_tables[:missions]
    filtered_missions = []

    @missions.each do |current_mission|
      current_mission_key = mission_id_to_locale_id(current_mission.id).to_sym
      if all_missions.key?(current_mission_key)
        filtered_missions.push(get_language_specific_mission(current_mission,
                                                             all_missions[current_mission_key],
                                                             I18n.locale))
      end
    end

    @missions = filtered_missions
  end

  # GET /missions/1
  # GET /missions/1.json
  def show;
  end

  # GET /missions/new
  def new
    @mission = Mission.new

    if params[:locale]
      @missions = by_lang
    else
      @missions = index
    end

  end

  # GET /missions/1/edit
  def edit
  end

  # POST /missions
  # POST /missions.json
  def create
    #set locale
    current_locale = params[:mission][:language]
    reset_locale current_locale

    #create a mission using the current_locale that has been set
    @mission = Mission.new(mission_params)

    #now save and return an appropriate error message
    respond_to do |format|
      if @mission.save
        format.html {redirect_to '/', notice: 'Mission was successfully created.'}
        format.json {render :show, status: :created, location: @mission}
      else
        format.html {render :new}
        format.json {render json: @mission.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /missions/1
  # PATCH/PUT /missions/1.json
  def update
    #set the current locale from the request parameters
    current_locale = params[:mission][:language]
    reset_locale current_locale

    #now update and return an appropriate error message
    respond_to do |format|
      if @mission.update(mission_params)
        format.html {redirect_to '/', notice: 'Mission was successfully updated.'}
        format.json {render :show, status: :ok, location: @mission}
      else
        format.html {render :edit}
        format.json {render json: @mission.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission.destroy
    respond_to do |format|
      format.html {redirect_to '/', notice: 'Mission was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Creates a mission object from data retrieved from locale and database
  # the mission object merges the title, instructions, and language which do not get
  # passed to the UI by default because they are calculated methods
  def get_language_specific_mission(current_mission, current_mission_info, language)
    {
        id: current_mission.id,
        title: current_mission_info[:title],
        instructions: current_mission_info[:instructions],
        duration: current_mission.duration,
        category: current_mission.category,
        language: language.to_s,
        created_at: current_mission.created_at,
        updated_at: current_mission.updated_at
    }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_mission
    @mission = Mission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mission_params
    params.require(:mission).permit(:title, :instructions, :duration, :category)
  end
end

private
#does this mission have a message in the given locale
def mission_supports_language(current_mission_hash, current_mission_key)
  current_mission_hash.key? current_mission_key.to_sym
end
