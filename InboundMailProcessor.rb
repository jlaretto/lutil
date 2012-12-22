require 'mailman'
require 'mailman/receiver/pop3'
require './External.rb'
#Mailman.config.maildir = '~/Maildir'
Mailman.config.pop3 = {
    :username => 'recent:legaldocs@laretto.net',
    :password => $password,
    :server   => 'pop.gmail.com',
    :port     => 995, # defaults to 110
    :ssl      => true # defaults to false
}
Mailman.config.poll_interval = 10
Mailman.config.ignore_stdin = true

Mailman::Application.run do
  to 'legaldocs@laretto.net' do

    puts "processing inbound email to #{message.to}"
    message.attachments.each do | attachment |

      puts "  processing attachment #{attachment.filename}"

      if (attachment.content_type.start_with?('application/pdf') && (user = User.find_by_email(message.from)).present?)

        #todo - should be cleaned up
        #try to locate the company based on subject - if no match, set to active company
        company = user.find_company_fuzzy(message.subject)
        company = user.active_company if company.nil?

        begin
          file = Tempfile.new(["import", ".pdf"])
          file.binmode
          path = file.path
          file.write attachment.body.decoded
          puts "wrote to tempfile #{path}"

          doc = Document.create(description: "Emailed", name: attachment.filename, company_id: company.id, document: file, import_requires_processing: true)
          doc.save!
          file.close!

          #add status feed update
          StatusUpdate.AddDocumentStatusUpdate(company, doc, "Document emailed from #{message.from}" )
        rescue Exception => e
          puts "Unable to save data for #{attachment.filename} because #{e.message}"
        end

      else
        puts "ignoring attached file #{attachment.filename} with content-type '#{attachment.content_type}'"
      end


    end

  end
  default do
    #delete message and log here
  end

end
