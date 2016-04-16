class PakketHub::EagerLoader

  def initialize(coll, *assocs)
    @collection = coll
    @associations = assocs
  end

  BATCH_SIZE = 3000

  def self.load(collection, *associations)
    preloader = new(collection, *associations)
    preloader.load
    collection
  end

  def load
    collection.each_slice(BATCH_SIZE) do |chunk|
      preloader = ActiveRecord::Associations::Preloader.new
      preloader.preload(chunk, associations)
    end
  end

  private

  def true_collection?
    !@collection.is_a?(ActiveRecord::Base)
  end

  def collection
    true_collection? ? @collection : [@collection]
  end

  attr_reader :associations
end