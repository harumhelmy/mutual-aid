class UpdateListingsAssociations < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :person, null: false, index: true, foreign_key: true, default: 1 # TODO - we'd need to figure this out...
    add_reference :listings, :service_area, null: false, index: true, foreign_key: true, default: 1 # TODO - need to drop db's rather than set default here?
    remove_reference :listings, :location, null: true, index: true, foreign_key: true
    add_reference :listings, :location, null: true, index: true, foreign_key: true
  end
end
