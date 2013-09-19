# -*- encoding: utf-8 -*-
module Qed
  module Mongodb
    class MongoidModel
      #include Mongoid::Document
      include Origin::Queryable

      #scope :between, lambda {|field, from, till| where(field.gte => from).where(field.lt => till)}
    end
  end
end