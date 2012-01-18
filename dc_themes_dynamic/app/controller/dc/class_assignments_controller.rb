class Dc::ClassAssignmentsController < Dc::BaseController
  
  before_filter :load_data
  
  def index
    @class_assignments = ClassAssignment.all
  end

  def show
    @class_assignment = ClassAssignment.find(params[:id])
  end

  def new
    @class_assignment = ClassAssignment.new
  end

  def create
    @class_assignment = ClassAssignment.new(params[:class_assignment])
    if @class_assignment.save
      redirect_to @class_assignment, :notice => "Successfully created class assignment."
    else
      render :action => 'new'
    end
  end

  def edit
    @class_assignment = ClassAssignment.find(params[:id])
  end

  def update
    @class_assignment = ClassAssignment.find(params[:id])
    if @class_assignment.update_attributes(params[:class_assignment])
      redirect_to @class_assignment, :notice  => "Successfully updated class assignment."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @class_assignment = ClassAssignment.find(params[:id])
    @class_assignment.destroy
    redirect_to class_assignments_url, :notice => "Successfully destroyed class assignment."
  end
  
  def load_data
    @id_muster = /\w+_id/
    params.each do |key,value|
        if @id_muster.match(key)
          @objekt_type = key.gsub('_id', '').classify
          @objekt_id = value
          @data = @objekt_type.constantize.find(@objekt_id)
        end
    end
  end
  
end
