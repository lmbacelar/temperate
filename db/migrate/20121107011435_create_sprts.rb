class CreateSprts < ActiveRecord::Migration
  def change
    create_table :sprts do |t|
      t.string  :name,  null: false
      t.decimal :rtpw,  null: false, default: 25.0
      t.integer :range, null: false, default: 11
      t.decimal :a,     null: false, default: 0.0
      t.decimal :b,     null: false, default: 0.0
      t.decimal :c,     null: false, default: 0.0
      t.decimal :d,     null: false, default: 0.0
      t.decimal :w660,  null: false, default: 0.0
      t.decimal :c1,    null: false, default: 0.0
      t.decimal :c2,    null: false, default: 0.0
      t.decimal :c3,    null: false, default: 0.0
      t.decimal :c4,    null: false, default: 0.0
      t.decimal :c5,    null: false, default: 0.0

      t.timestamps
    end

    add_index :sprts, :name, unique: true
  end
end
