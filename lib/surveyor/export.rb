module Surveyor
  module Export
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_survey_exporter
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
    end
    
  end
end