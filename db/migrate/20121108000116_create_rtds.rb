class CreateRtds < ActiveRecord::Migration
  def change
    create_table :rtds do |t|
      t.string  :name,  null: false
      t.decimal :r0,    null: false, default: 100.0
      t.decimal :a,     null: false, default:   3.9083e-03
      t.decimal :b,     null: false, default:  -5.7750e-07
      t.decimal :c,     null: false, default:  -4.1830e-12

      t.timestamps
    end

    add_index :rtds, :name, unique: true
  end
end
