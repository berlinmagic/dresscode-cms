# encoding: utf-8
class ContactFormsController < BaseController
  
  # => Public - ContactForms
  
  def create
    @contact_form = ContactForm.new( params[:contact_form] )
    @contact_form.user_ip = request.remote_ip
    if @contact_form.save
      @success = true
    else
      @success = false
    end
    respond_to do |f|
      f.html  { redirect_to :back, :alert => 'Fehler .. Bitte Prüfen Sie Ihre Eingaben.' }
      f.js    { render 'public/contact_forms/sended' }
    end
  end
  
end