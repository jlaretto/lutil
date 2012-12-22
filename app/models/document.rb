class Document < ActiveRecord::Base
  attr_accessible :description, :document_type, :name, :company_id, :applicable_date, :aws_key, :document_content_type, :document, :document_file_name, :import_requires_processing

  belongs_to :company

  has_many :document_tags

  #Paper clip gem
  # adds attributes:
  #document_file_name
  #document_file_size
  #document_content_type
  #document_updated_at
  has_attached_file :document,
                    processors: [:ConvertPdfToSwf],
                    styles: { swf: { format: "swf"} },
                    path: ":rails_root/_uploads/:attachment/:id/:filename",
                    url: "/flashdoc/:id"

   #   has_attached_file :avatar,
   #   :path => ":rails_root/_upload/system/:attachment/:id/:style/:filename",
   #   :url => "/system/:attachment/:id/:style/:filename"

  #saves file into our data directory


   validates :document, attachment_presence: true
   validates_with AttachmentContentTypeValidator, attributes: :document, content_type: "application/pdf"


  def saveFile( upload )
    filename =  upload.original_filename

    directory = "public/data"

    # create the file path
    path = File.join(directory, filename)
    new_aws_key = ""

    # write the file
    File.open(path, "wb") do |f|
      f.write(upload.read)
      t = f.mtime
      new_aws_key = "#{company.name}-#{t.to_i}-#{filename}"

    end

    self.aws_key = new_aws_key

    #upload to S3
    bucket = Document.get_bucket(company)
    s3Obj = bucket.objects[self.aws_key]
    s3Obj.write(Pathname.new(path))
  end

  def self.documents_requiring_processing(company)
    arrCompanies = Document.find_all_by_company_id(company.id)
    arr = []
    arrCompanies.each { |c| arr << c unless !c.import_requires_processing }
    arr
  end

  #todo
  def conform_filename

  end

  def s3url
    bucket = Document.get_bucket(company)
    s3obj = bucket.objects[aws_key]
    url = s3obj.url_for(:read)
    return url
  end

  def self.get_bucket(company)
    #load S3
    s3 ||= AWS::S3.new

    #this loads (or creates the bucket)
    bucket = s3.buckets.create("jlaretto_company-#{company.id}")

    #for readability, this next line not needed though
    return bucket
  end

 # def swf_file
 #     'doc\3'

 #   if document_file_name.present?
 #      "#{File.basename(document_file_name, File.extname(document_file_name))}.swf"
 #   else
 #     ""
 #   end
 # end

  #TODO migrate this to a module to extend all saves with object logging
  #def save(*args)


  #  jsonstring = valid? ? Document.find_by_id(id).to_json : nil

  #  super(*args)   # do the original

  #  ChangeLog.create(objid: id, objtype: "Document", objjson: jsonstring, user_id: current_user.id, company_id: company_id).save! unless jsonstring.nil?

  #end




end
