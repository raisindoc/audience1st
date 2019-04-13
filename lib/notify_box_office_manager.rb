class NotifyBoxOfficeManager 
    
    def self.notify(template_name, params, subject)
        Mailer.general_mailer(template_name, params, subject)
    end

end
