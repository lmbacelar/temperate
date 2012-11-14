class CreateThermocouples < ActiveRecord::Migration
  def change
    create_table :thermocouples do |t|
      t.string  :name,  null: false
      t.string  :kind,  null: false, default: :k
      t.decimal :a3,    null: false, default: 0.0e+00
      t.decimal :a2,    null: false, default: 0.0e+00
      t.decimal :a1,    null: false, default: 0.0e+00
      t.decimal :a0,    null: false, default: 0.0e+00

      t.timestamps
    end

    add_index :thermocouples, :name, unique: true
  end
end
