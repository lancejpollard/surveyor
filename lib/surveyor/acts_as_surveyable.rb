require 'active_record'

module Surveyor
  module Surveyable
    # if you add this to your routes:
    # map.resources :events, :has_many => :surveys
    # you will have urls like
    # /events/1/surveys/my_survey
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_surveyable
        # each model will reference lots of surveys
        has_many :model_surveys, :as => :surveyable, :dependent => :destroy, :include => :survey
        has_many :surveys, :through => :model_surveys

        include Surveyor::Surveyable::InstanceMethods
      end
    end
    
    module InstanceMethods
      # added to SurveyorController to find only the surveys
      # for the polymorphic object
      def find_surveyable(params)
        params.each do |name, value|
          if name =~ /(.+)_id$/
            return $1.classify.constantize.find(value).surveys
          end
        end
        nil
      end
    end
  end
end

ActiveRecord::Base.send(:include, Surveyor::Surveyable)