class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  def index
    @sections = Section.includes(:teacher, :subject, :classroom).all
  end

  def show
  end

  def new
    @section = Section.new
  end

  def create
    @section = Section.new(section_params)
    if @section.save
      redirect_to @section, notice: 'Section was successfully created.'
    else
      render :new
    end
  end

  # Other CRUD actions...

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(
      :teacher_id, :subject_id, :classroom_id, :start_time, :end_time,
      :monday, :tuesday, :wednesday, :thursday, :friday,
      :capacity, :semester, :year
    )
  end
end
