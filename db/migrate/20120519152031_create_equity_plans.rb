class CreateEquityPlans < ActiveRecord::Migration
  def change
    create_table :equity_plans do |t|
      t.string :description                             #Name of Plan
      t.integer :capitalization_record_id        #Capitalization Record is Preferred, Common, etc.
      t.float :authorized_amount                 #Amount of Reserved Equity
      t.datetime :board_approval_date            #Date of Board Adoption
      t.string :stockholder_approval_date        #Date of Stockholder Approval
      t.string :amendment_history                #Blob of Amendments

      t.timestamps
    end
  end
end
