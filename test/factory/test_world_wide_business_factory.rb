require 'mongo'
require 'test_constants'

module Qed
  module Mongodb
    module Test
      class Factory
        module WorldWideBusinessMixins
          attr_accessor :options

          def initialize(options)
            raise ArgumentError.new("Options needs to be an array!") unless options.is_a?(Array)
            @options = options
          end

          def rec_path(tree, leaf, reversed)
            raise ArgumentError.new("'Tree' needs a to be a hash!") unless tree.is_a?(Hash)
            return [] if leaf.nil?

            if reversed
              [leaf.to_s] + self.rec_path(tree, tree[leaf], reversed)
            else
              self.rec_path(tree, tree[leaf], reversed) + [leaf.to_s]
            end
          end

          def get_path(tree, leaf, prefix, return_hsh = false, reversed = false)
            path = rec_path(tree, leaf, reversed)

            if( return_hsh )
              path = {}.tap do |hsh|
                path.each_with_index{|element, i| hsh[prefix+i.to_s] = element}
              end
            end

            return path
          end

          #def do_save!(obj)
          #  WorldWideBusiness.mongo_collection.insert(create_insert_hsh(obj))
          #end

          def to_hash
            hsh = {}

            options.each do |option|
              hsh.merge!(path(option[:dimension], option[:value], true))
            end
            return hsh
          end
        end


        class WorldWideBusiness
          @@mongo_db = Mongo::Connection.new('127.0.0.1', 27017).db('qed_test')
          @@collection = @@mongo_db.collection('world_wide_business')

          def self.mongo_db
            @@mongo
          end

          def self.mongo_collection
            @@collection
          end

          def self.startup(line_items = WORLD_WIDE_BUSINESS )
            line_items.each do |item|
              hsh = {}
              item[:line_item].each do |line_item_part|
                hsh = hsh.merge(line_item_part[:class].new(line_item_part[:options]).to_hash)
              end

              (1..item[:amount]).each do |i|
                WorldWideBusiness.mongo_collection.insert({:value => hsh})
              end
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

            DIMENSION_PREFIXES = {
                :devision => "DIM_DEV_"
            }

            DIMENSION_TREES   = {
              :devision  => {
                  SERVICES      => ALL,
                  GOODS         => ALL,
                  SW_CONSULTING => SERVICES,
                  AIRPLANES     => GOODS,
                  MS            => SW_CONSULTING,
                  JETPLANES     => AIRPLANES,
                  DEV_M         => MS
              }
            }

            def path(dimension, leaf, return_hsh = false, reversed = false)
              get_path(DIMENSION_TREES[dimension.to_sym], leaf, DIMENSION_PREFIXES[dimension.to_sym], return_hsh, reversed)
            end

            def save!
              do_save!(self)
            end
          end

          class GeographicDimension
            include Qed::Mongodb::Test::Factory::WorldWideBusinessMixins

            ALL         = "ALL"
            EUROPE      = "EUROPE"
            DE          = "DE"
            BERLIN      = "BERLIN"

            DIMENSION_PREFIXES = {
                :location => "DIM_LOC_"
            }

            # dimension tree for location
            DIMENSION_TREES = {
              :location => {
                  # CONTINENTS
                  EUROPE      =>  ALL,
                  # CITIES
                  BERLIN      =>  EUROPE
              }
            }

            def path(dimension, leaf, return_hsh = false, reversed = false)
              get_path(DIMENSION_TREES[dimension.to_sym], leaf, DIMENSION_PREFIXES[dimension.to_sym], return_hsh, reversed)
            end

            def save!
              do_save!(self)
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

            DIMENSION_PREFIXES = {
                :revenue => "DIM_DEV_"
            }

            DIMENSION_TREES = {
              :revenue => {
                GOODS       => ALL,
                ELECTRONICS => ALL,
                SERVICE     => ALL,
                A380        => GOODS,
                CPLUSPLUS   => SERVICE
              }
            }

            def path(dimension, leaf, return_hsh = false, reversed = false)
              get_path(DIMENSION_TREES[dimension.to_sym], leaf, DIMENSION_PREFIXES[dimension.to_sym], return_hsh, reversed)
            end

            def save!
              do_save!(self)
            end
          end

          BERLIN_A380_JETPLANES                 = [
              {:class => GeographicDimension,         :options => [{:dimension => :location, :value => GeographicDimension::BERLIN}]},
              {:class => RevenueDimension,            :options => [{:dimension => :revenue, :value => RevenueDimension::A380}]},
              {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision, :value => BusinessDevisionDimension::JETPLANES}]}
          ]
          BERLIN_A380_JETPLANES_AMOUNT          = 10
          BERLIN_CPLUSPLUS_DEV_M                = [
              {:class => GeographicDimension,         :options => [{:dimension => :location, :value => GeographicDimension::BERLIN}]},
              {:class => RevenueDimension,            :options => [{:dimension => :revenue, :value => RevenueDimension::CPLUSPLUS}]},
              {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision, :value => BusinessDevisionDimension::DEV_M}]}
          ]
          BERLIN_CPLUSPLUS_DEV_M_AMOUNT         = 8

          WORLD_WIDE_BUSINESS = [
            {:line_item => BERLIN_A380_JETPLANES,                     :amount => BERLIN_A380_JETPLANES_AMOUNT},
            {:line_item => BERLIN_CPLUSPLUS_DEV_M,                    :amount => BERLIN_CPLUSPLUS_DEV_M_AMOUNT}
          ]

          # ========================= WEB PARAMETER =============================================================
          ACTION_NAME_WORLD_WIDE_BUSINESS               =     "world_wide_business"

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
