class ModelSurvey < ActiveRecord::Base
  belongs_to :survey
  belongs_to :surveyable, :polymorphic => true
  
  def after_destroy
    if survey.model_surveys.count.zero?
      survey.destroy
    end
  end
end