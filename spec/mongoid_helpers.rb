def drop_collections(models)
  models.each do |model|
    model.collection.drop
  end
end

def empty_collections(models)
  models.each do |model|
    model.delete_all
  end
end

def get_mongoid_models
  documents = []
  Dir.glob("#{Rails.root}/app/models/*.rb").sort.each do |file|
    model_path = File.basename(file, ".rb")
    begin
      klass = model_path.map(&:classify).join('::').constantize
      if klass.ancestors.include?(Mongoid::Document) && !klass.embedded
        documents << klass
      end
    rescue => e
      # Just for non-mongoid objects that dont have the embedded
      # attribute at the class level.
    end
  end
  documents
end
