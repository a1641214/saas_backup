class EnrolmentMailer < ApplicationMailer
    default from: 'enrolmentassistant@gmail.com'
    def enrolment_email(id)
        @student = Student.find(id)
        @courses = @student.courses
        mail(to: 'enrolmentassistant@gmail.com', subject: 'Enrolment Update')
    end

    def receive(email)
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