class CreateModelSurveys < ActiveRecord::Migration
  def self.up
    create_table :model_surveys do |t|
      t.column :survey_id, :integer
      t.column :surveyable_id, :integer
      
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.column :surveyable_type, :string
      
      t.column :created_at, :datetime
    end
    
    add_index :model_surveys, :survey_id
    add_index :model_surveys, [:surveyable_id, :surveyable_type]
  end
  
  def self.down
    drop_table :model_surveys
  end
end