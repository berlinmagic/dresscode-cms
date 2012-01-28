# encoding: utf-8
class Dc::ContactFormsController < Dc::BaseController
  
  def index
    @contact_forms = ContactForm.all
  end
  
  def show
    @contact_form = ContactForm.find( params[:id] )
    @contact_form.unread = false
    @contact_form.save
  end
  

end
