class EnrolmentMailer < ApplicationMailer
    default from: 'enrolmentassistant@gmail.com'
    def enrolment_email(id)
        @student = Student.find(id)
        mail(to: 'enrolmentassistant@gmail.com', subject: 'Sample Email')
    end

    def receive(email)
        puts 'Email received'
        return unless email.has_attachments?
        email.attachments.each do |attachment|
        end
    end
end
