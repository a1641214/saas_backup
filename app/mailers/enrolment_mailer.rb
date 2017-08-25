class EnrolmentMailer < ApplicationMailer
    default from: 'enrolmentassistant@gmail.com'
    def enrolment_email(id)
        @student = Student.find(id)
        mail(to: 'enrolmentassistant@gmail.com', subject: 'Sample Email')
    end

    def receive(email)
        return unless email.has_attachments?
        email.attachments.each do |attachment|
            file = StringIO.new(attachment.decoded)
            file.class.class_eval { attr_accessor :original_filename, :content_type }
            file.original_filename = attachment.filename
            file.content_type = attachment.mime_type
            dir = Rails.root.join('db', 'csv')
            File.open(dir.join(file.original_filename), 'w+') do |file_write|
                file_write.write(file.read)
            end
        end
    end
end
