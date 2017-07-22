class UpdateSeason < ActiveRecord::Migration[5.0]
  def change
     change_column_default :leagues, :season, 2017
  end
end
