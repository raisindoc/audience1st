class GeneralMailer < ActionMailer::Base
    
    def self.notify(template_name, params, subject)
        @num,@customers = params[:num], params[:customers]
        @subject = subject
        mail(:to => params[:recipient],
             :subject => @subject, 
             :template_name => template_name)        
    end

end
