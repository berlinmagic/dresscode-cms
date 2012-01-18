class Dc::TwidgetsController < Dc::BaseController
  def index
    @twidgets = Twidget.all
  end

  def show
    @twidget = Twidget.find(params[:id])
  end

  def new
    @twidget = Twidget.new
  end

  def create
    @twidget = Twidget.new(params[:twidget])
    if @twidget.save
      redirect_to @twidget, :notice => "Successfully created twidget."
    else
      render :action => 'new'
    end
  end

  def edit
    @twidget = Twidget.find(params[:id])
  end

  def update
    @twidget = Twidget.find(params[:id])
    if @twidget.update_attributes(params[:twidget])
      redirect_to @twidget, :notice  => "Successfully updated twidget."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @twidget = Twidget.find(params[:id])
    @twidget.destroy
    redirect_to twidgets_url, :notice => "Successfully destroyed twidget."
  end
end
