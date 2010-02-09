class Response < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
         
  # Associations
  belongs_to :response_set
  belongs_to :question
  belongs_to :answer
  
  # Validations
  validates_presence_of :response_set_id, :question_id, :answer_id
      
  acts_as_response # includes "as" instance method

  def selected
    !self.new_record?
  end
  
  alias_method :selected?, :selected
  
  def selected=(value)
    true
  end
  
  def correct?
    question.correct_answer_id.nil? or self.answer.response_class != "answer" or (question.correct_answer_id.to_i == answer_id.to_i)
  end
  
  def to_q_and_a
    return {:question => question_text, :answer => answer_text}
  end
  
  def question_text
    self.question.text
  end
  
  def answer_text
    if self.answer.response_class == "answer" and self.answer_id
      return self.answer.text
    else
      return "#{(self.string_value || self.text_value || self.integer_value || self.float_value || self.datetime_value || nil).to_s}"
    end
  end
  
  def to_s # used in dependency_explanation_helper
    answer_text
  end
  
end
