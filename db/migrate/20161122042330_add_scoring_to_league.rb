class AddScoringToLeague < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :pa_yd, :float, default: 0.04
    add_column :leagues, :pa_td, :int, default: 6
    add_column :leagues, :pa_int, :int, default: -2
    add_column :leagues, :ru_yd, :float, default: 0.1
    add_column :leagues, :ru_td, :int, default: 6
    add_column :leagues, :re_yd, :float, default: 0.1
    add_column :leagues, :rec, :float, default: 0.5
    add_column :leagues, :re_td, :int, default: 6
    add_column :leagues, :fum, :int, default: -1
    add_column :leagues, :fuml, :int, default: -1
    add_column :leagues, :tpc, :int, default: 2
  end
end
