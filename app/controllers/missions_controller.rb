class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy]

  # GET /missions
  # GET /missions.json
  def index
    # we should retrieve all locals and get their  missions
    @missions = Mission.all
    all_missions_in_all_languages = []
    local_translation_tables = I18n.backend.send(:translations)

    @missions.each do |current_mission|
      current_mission_key = generate_mission_id current_mission.id

      local_translation_tables.each do |current_locale|
        current_mission_hash = current_locale[1][:missions]

        if current_mission_hash.key? current_mission_key.to_sym

          current_mission_info = current_mission_hash[current_mission_key.to_sym]
          mission_in_specific_language = {
              id: current_mission.id,
              title: current_mission_info[:title],
              instructions: current_mission_info[:instructions],
              duration: current_mission.duration,
              category: current_mission.category,
              created_at: current_mission.created_at,
              updated_at: current_mission.updated_at
          }
          all_missions_in_all_languages.push(mission_in_specific_language)
        end
      end
    end

    @missions = all_missions_in_all_languages
  end

  def by_lang
    @missions = Mission.all
    local_translation_tables = I18n.backend.send(:translations)[I18n.locale]
    all_missions = local_translation_tables[:missions]
    filtered_missions = []
    @missions.each do |current_mission|
      current_mission_key = generate_mission_id(current_mission.id).to_sym
      filtered_missions.push(current_mission) if all_missions.key?(current_mission_key)
    end

    @missions = filtered_missions
  end

  # GET /missions/1
  # GET /missions/1.json
  def show
  end

  # GET /missions/new
  def new
    @mission = Mission.new
    @missions = index
  end

  # GET /missions/1/edit
  def edit
  end

  # POST /missions
  # POST /missions.json
  def create
    current_locale = params[:mission][:language]
    reset_locale current_locale

    @mission = Mission.new(mission_params)

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
    current_locale = params[:mission][:language]
    reset_locale current_locale

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
      format.html {redirect_to missions_url, notice: 'Mission was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_mission
    @mission = Mission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mission_params
    params.require(:mission).permit(:title, :instructions, :duration, :category)
  end
end
