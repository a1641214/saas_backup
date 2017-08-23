class ExampleMailer < ApplicationMailer
    default from: 'enrolmentassistant@gmail.com'
    def sample_email
        mail(to: 'enrolmentassistant@gmail.com', subject: 'Sample Email')
    end

    def receive(email)
        puts 'Email received'
        page = Page.find_by(address: email.to.first)
        page.emails.create(
            subject: email.subject,
            body: email.body
        )
        return unless email.has_attachments?
        email.attachments.each do |attachment|
            page.attachments.create(
                file: attachment,
                description: email.subject
            )
        end
    end
end
