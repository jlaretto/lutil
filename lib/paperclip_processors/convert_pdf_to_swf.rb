require "paperclip"
module Paperclip
  class ConvertPdfToSwf < Processor

      attr_accessor :file, :options, :format

      def initialize file, options = {}, attachment = nil
        super
        @file           = file
        @params         = options[:params]
        @current_format = File.extname(@file.path)
        @basename       = File.basename(@file.path, @current_format)
        @format         = options[:format]

        @params = "-f -T 9 -t -s storeallcharacters" if @params.nil?

      end


      def make

        dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
        begin
          parameters = []
          parameters << @params
          parameters << ":source"
          parameters << ":dest"

          parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

          success = Paperclip.run("/usr/local/bin/pdf2swf", parameters, source: "#{File.expand_path(@file.path)}",dest: File.expand_path(dst.path))
        rescue Cocaine::CommandLineError => e
          raise PaperclipError, "There was an error converting #{@basename} to swf"
        end
        dst
      end

    end
end

