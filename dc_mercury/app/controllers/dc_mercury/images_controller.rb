class DcMercury::ImagesController < DcMercuryController

  respond_to :json

  # POST /images.json
  def create
    @image = DcMercury::Image.new(params[:image])
    @image.save
    respond_with @image
  end

  # DELETE /images/1.json
  def destroy
    @image = DcMercury::Image.find(params[:id])
    @image.destroy
    respond_with @image
  end

end
