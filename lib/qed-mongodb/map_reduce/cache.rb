module Qed
  module Mongodb
    module MapReduce
      class Cache
        def self.find(options = {})
          data_array = []
          cached = false

          db = options[:database]
          fm = options[:filter_model]
          mapreduce_model = options[:mapreduce_models].first

          query = Qed::Mongodb::MongoidModel.where(:digest_with_date => fm.digest())

          cursor = db.collection(mapreduce_model.mr_collection).find(query.selector)
          
          if cursor.count > 0
            data_array = cursor.find().to_a.first["result"]
            cached = !(options[:saved] || false)
          end
                  
          return {:cached => cached, :result => data_array}
        end

        # TODO: make upsert for document, if always insert then either
        # TODO: a) each request generates a new document or
        # TODO: b) updated stuff not saved (insert with already existing key => no update)
        def self.save(options = {})
          db = options[:database]
          fm = options[:filter_model]
          mapreduce_model = options[:mapreduce_models].first
          cursor = options[:cursor]

          collection = db.collection(mapreduce_model.mr_collection)

          data = {
              :digest_with_date       => fm.digest(),
              :result                 => cursor.find().to_a
          }

          collection.insert(data)

          find(options.merge({:saved => true}))
        end
      end
    end
  end
end