class AddPolymorphismToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :surveyable_id, :integer
    add_column :surveys, :surveyable_type, :integer
  end

  def self.down
    remove_column :surveys, :surveyable_id
    remove_column :surveys, :surveyable_type
  end
end