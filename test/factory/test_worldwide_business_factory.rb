require 'mongo'

module Qed
  module Mongodb
    module Test
      class Factory
        module WorldWideBusinessMixins

          def get_path(leaf, tree)
              return [] if leaf.nil?

              [leaf.to_s] + self.path(tree[leaf])
          end

          def save!(obj)
            WorldWideBusiness.mongo_collection.insert(create_insert_hsh(obj))
          end

          def create_insert_hsh(obj)
            {}.tap do |hsh|
              obj.markup.each_with_index do |m, i|
                key = "dim_#{i}"
                hsh[key] = m.to_s.upcase
              end

              return {:value =>  hsh.merge(obj.attributes)}
            end
          end
        end


        class WorldWideBusiness
          @@mongo_db = Mongo::Connection.new('127.0.0.1', 27017).db('qed_test')
          @@collection = @@mongo_db.collection('scale_of_universe')

          def self.mongo_db
            @@mongo
          end

          def self.mongo_collection
            @@collection
          end

          def self.startup(line_items)
            line_items.each do |item|
              (1..item[:amount]).each {|i| item[:line_item].new.save!}
            end
          end

          def self.sell_out
            WorldWideBusiness.mongo_collection.drop
          end

          class BusinessDevisionDimension
            include Qed::Mongodb::Test::Factory::WorldWideBusinessMixins
            ALL             = "ALL"
            SERVICES        = "SERVICES"
            GOODS           = "GOODS"
            SW_CONSULTING   = "SW_CONSULTING"
            AIRPLANES       = "AIRPLANES"
            MS              = "MS"
            JETPLANES       = "JETPLANES"
            DEV_M           = "DEV_M"

            TREE  = {
                SERVICES      => ALL,
                GOODS         => ALL,
                SW_CONSULTING => SERVICES,
                AIRPLANES     => GOODS,
                MS            => SW_CONSULTING,
                JETPLANES     => AIRPLANES,
                DEV_M         => MS
            }

            def path(leaf)
              get_path(leaf,TREE)
            end
          end

          class GeographicDimension
            include Qed::Mongodb::Test::Factory::WorldWideBusinessMixins
            ALL         = "ALL"
            EUROPE      = "EUROPE"
            DE          = "DE"
            BERLIN      = "BERLIN"

            TREE = {
                # CONTINENTS
                EUROPE      =>  ALL,
                # CITIES
                BERLIN      =>  EUROPE,

            }

            def path(leaf)
              get_path(leaf,TREE)
            end
          end

          class RevenueDimension
            include Qed::Mongodb::Test::Factory::WorldWideBusinessMixins
            ALL                 = "ALL"
            GOODS               = "GOODS"
            ELECTRONICS         = "ELECTRONICS"
            SERVICE             = "SERVICE"
            A380                = "A380"
            CPLUSPLUS           = "C++"

            TREE = {
                GOODS       => ALL,
                ELECTRONICS => ALL,
                SERVICE     => ALL,
                A380        => GOODS,
                CPLUSPLUS   => SERVICE
            }

            def path(leaf)
              get_path(leaf,TREE)
            end
          end

          BERLIN_A380_JETPLANES                 = {:geographie => GeographicDimension::BERLIN, :revenue => RevenueDimension::A380, :business => BusinessDevisionDimension::JETPLANES}
          BERLIN_A380_JETPLANES_AMOUNT          = 10
          BERLIN_CPLUSPLUS_DEV_M                = {:geographie => GeographicDimension::BERLIN, :revenue => RevenueDimension::CPLUSPLUS, :business => BusinessDevisionDimension::DEV_M}
          BERLIN_CPLUSPLUS_DEV_M_AMOUNT         = 8

          WORLD_WIDE_BUSINESS = [
            {:line_item => BERLIN_A380_JETPLANES,                     :amount => BERLIN_A380_JETPLANES_AMOUNT},
            {:line_itme => BERLIN_CPLUSPLUS_DEV_M,                    :amount => BERLIN_CPLUSPLUS_DEV_M_AMOUNT}
          ]

          # ========================= WEB PARAMETER =============================================================
          ACTION_NAME_WORLD_WIDE_BUSINESS               =

          PARAMS_WORLD_WIDE_BUSINESS =
          {
            DRILLDOWN_LEVEL_CURRENT           =>  9999999,
            ACTION                            =>  ACTION_NAME_WORLD_WIDE_BUSINESS,
            ACTION_NAME                       =>  ACTION_NAME_WORLD_WIDE_BUSINESS,
            CONTROLLER                        =>  CONTROLLER_VALUE
          }

          #def self.amount_of_objects_in_universe(type)
          #  type = type.to_sym.downcase
          #
          #  EXAMPLE_UNIVERSE.each do |bp|
          #    return bp[:amount] if bp[:blueprint]::TYPE.eql?(type)
          #  end
          #end
          #
          #def self.amount_of_types_in_same_dimension(type)
          #  type = type.to_sym.downcase
          #  SCALE.each do |s|
          #    return s.size if s.include?(type)
          #  end
          #
          #  raise Exception.new("You provided a type #{type} which doesn't exist in this Universe. I have to raise you")
          #end
        end
      end
    end
  end
end
