# encoding: utf-8
class KontaktMailer < ActionMailer::Base
  
  default :from => DC::Config[:mails_from]
  
  def contact_mail(data)
    @data = data
    mail  :to     =>  DC::Config[:mails_to],
          :bcc    =>  DC::Config[:mail_bcc],
          :from   =>  data.email
  end
  
  def answer_mail(data)
    @data = data
    mail  :to     =>  data.email,
          :bcc    =>  Strangecms::Kontakt::Config[:mail_bcc]
  end
  
  def thankyou_mail(data)
    @data = data
    mail  :to     =>  data.email
  end
  
end
