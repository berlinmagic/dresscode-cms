class Dc::StyleClassesController < Dc::BaseController
  
  before_filter :load_data
  
  def index
    @style_classes = StyleClass.all
  end

  def show
    @style_class = StyleClass.find(params[:id])
  end

  def new
    @style_class = StyleClass.new
  end

  def create
    @style_class = StyleClass.new(params[:style_class])
    if @style_class.save
      redirect_to @style_class, :notice => "Successfully created style class."
    else
      render :action => 'new'
    end
  end

  def edit
    @style_class = StyleClass.find(params[:id])
  end

  def update
    @style_class = StyleClass.find(params[:id])
    if @style_class.update_attributes(params[:style_class])
      redirect_to @style_class, :notice  => "Successfully updated style class."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @style_class = StyleClass.find(params[:id])
    @style_class.destroy
    redirect_to style_classes_url, :notice => "Successfully destroyed style class."
  end
  
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
    
  def available_style_classes
    @available_style_classes = StyleClass.all
    @available_style_classes.delete_if { |sc| @data.style_classes.include?(sc) }
  end

  def select_style_class
    @style_class = StyleClass.find(params[:id])
    @data.style_classes << @style_class
    @data.save
    @style_classes = @data.style_classes
    @available_style_classes = StyleClass.all
    @available_style_classes.delete_if { |sc| @style_classes.include?(sc) }
  end
  
  def remove_style_class
    @killa = ClassAssignment.where("target_id = ? AND target_type = ? AND style_class_id = ?", @objekt_id, @objekt_type, params[:id])
    @killa.each do |kill|
      kill.destroy
    end
    @style_classes = @data.style_classes
    @available_style_classes = StyleClass.all
    @available_style_classes.delete_if { |sc| @style_classes.include?(sc) }
    # => render :nothing => true
  end
  
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
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
