class Dc::TagAssignmentsController < Dc::BaseController
  def index
    @tag_assignments = TagAssignment.all
  end

  def show
    @tag_assignment = TagAssignment.find(params[:id])
  end

  def new
    @tag_assignment = TagAssignment.new
  end

  def create
    @tag_assignment = TagAssignment.new(params[:tag_assignment])
    if @tag_assignment.save
      redirect_to @tag_assignment, :notice => "Successfully created tag assignment."
    else
      render :action => 'new'
    end
  end

  def edit
    @tag_assignment = TagAssignment.find(params[:id])
  end

  def update
    @tag_assignment = TagAssignment.find(params[:id])
    if @tag_assignment.update_attributes(params[:tag_assignment])
      redirect_to @tag_assignment, :notice  => "Successfully updated tag assignment."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tag_assignment = TagAssignment.find(params[:id])
    @tag_assignment.destroy
    redirect_to tag_assignments_url, :notice => "Successfully destroyed tag assignment."
  end
end
