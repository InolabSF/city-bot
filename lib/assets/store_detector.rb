require 'trigram'
require './lib/assets/google_client'


class StoreDetector

  # initialize
  def initialize
  end

  # get store
  def get_store_by_name(name)
    detected_store = nil
    highest_score = 0.0
    stores = Store.all
    stores.each do |store|
      score = Trigram.compare(store.name, name)
      return store if score == 1.0

      if score > highest_score
        highest_score = score
        detected_store = store
      end
    end

    return (highest_score > 0.05) ? detected_store : nil
  end

end

