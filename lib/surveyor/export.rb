module Surveyor
  module Export
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_exportable_survey        
        after_save :update_survey_file
        
        include Surveyor::Export::InstanceMethods
      end
    end
    
    module InstanceMethods
      def export_to_xml

      end
      
      # TODO
      def to_csv
        require 'faster_csv'
        responses = Survey.response_sets.last.responses
        
        csv_string = FasterCSV.generate do |csv|
          # header row
          header = []
          body = []
          responses.each do |response|
            header << response.question.text
            body << response.answer.text
          end
          csv << header
          csv << body
        end
        csv_string
        # send it to the browsah
        # send_data(csv_string),
        #          :type => 'text/csv; charset=iso-8859-1; header=present',
        #          :disposition => "attachment; filename=LANCE_SURVEY_TEST.csv"
      end
      
      def survey_dsl
        path = File.join(RAILS_ROOT, "surveys/#{get_survey_name}")
        @survey_dsl ||= IO.read(path) unless !File.exists?(path)
        return @survey_dsl
      end
      
      def survey_dsl=(content)
        @survey_dsl = content
      end
      
      def get_survey_name
        "#{title.gsub(/[^a-zA-Z\ \_\-]/, "").parameterize.gsub('-', '_').gsub('_survey', '')}_survey.rb"
      end
      
      # if you have created dynamically the survey dsl file,
      # pass it to the @survey_file variable, and it will save it
      def update_survey_file
        return unless @survey_dsl
        # extract out later
        dir = "surveys"
        FileUtils.mkdir(dir) unless File.exists?(dir)
        name = "#{get_survey_name}_survey.rb"
        File.open(File.join(dir, name), 'w') {|f| f.write(@survey_dsl) }
      end
      
    end
    
  end
end

ActiveRecord::Base.send(:include, Surveyor::Export)