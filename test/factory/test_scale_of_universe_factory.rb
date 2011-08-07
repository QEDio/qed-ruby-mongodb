require 'mongo'

module Qed
  module Mongodb
    module Test
      class Factory
        module ScaleOfUniversClassMixins
          # markup represents the different dimensions for this object in a datacube
           # attributes represents the facts for this object in a datacube
          attr_reader :markup, :attributes

          def initialize
            @markup, @attributes = self.class.generate_fabrice(self.class)
          end

          def save!
            self.class.save!(self)
          end
        end


        class ScaleOfUniverse
          PLANCK_LENGTH = :planck_length
          NEUTRINO      = :neutriono
          PREON         = :preon
          QUARK         = :quark
          ELECTRON      = :electron
          PROTON        = :proton
          NEUTRON       = :neutron
          ATOM          = :atom
          ATOM1         = :atom1
          ATOM2         = :atom2

          # we translate the size of the things into something called dimensions
          # those dimensions are datawarehouse dimensions, and have nothing to do with pysical dimensions

          SIZE_0  = [PLANCK_LENGTH]
          SIZE_1  = [NEUTRINO]
          SIZE_2  = [PREON]
          SIZE_3  = [QUARK]
          SIZE_4  = [PROTON, NEUTRON]
          SIZE_5  = [ATOM, ATOM1, ATOM2]

          SCALE   = [SIZE_0, SIZE_1, SIZE_2, SIZE_3, SIZE_4, SIZE_5]

          @@mongo_db = Mongo::Connection.new('127.0.0.1', 27017).db('qed_test')
          @@collection = @@mongo_db.collection('scale_of_universe')

          def self.mongo_db
            @@mongo
          end

          def self.mongo_collection
            @@collection
          end

          def self.big_bang(blueprints)
            blueprints.each do |bp|
              (1..bp[:amount]).each {|i| bp[:blueprint].new.save!}
            end
          end

          # since this makes for a cyclic univers it's a nice fit here
          def self.big_crunch
            ScaleOfUniverse.mongo_collection.drop
          end

          class Meaning
            def self.generate_fabrice(base_clasz)
              h = {:markup => [], :attributes => {}}

              while(!base_clasz.eql?(Meaning))
                h[:markup] = h[:markup].insert(0, base_clasz::TYPE)
                h[:attributes] = base_clasz::ATTRIBUTES.merge!(h[:attributes])
                base_clasz = base_clasz.superclass
              end
              return h[:markup], h[:attributes]
            end

            def self.save!(obj)
              ScaleOfUniverse.mongo_collection.insert(create_insert_hsh(obj))
            end

            def self.create_insert_hsh(obj)
              {}.tap do |hsh|
                obj.markup.each_with_index do |m, i|
                  key = "dim_#{i}"
                  hsh[key] = m.to_s.upcase
                end

                return {:value =>  hsh.merge(obj.attributes)}
              end
            end
          end

          class PlanckLength < Meaning
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = PLANCK_LENGTH
            ATTRIBUTES = {:length => 1, :width => 1}
          end

          class Neutrino < PlanckLength
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = NEUTRINO
            ATTRIBUTES = {:length => 2, :width => 2}
          end

          class Electron < PlanckLength
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = ELECTRON
            ATTRIBUTES = {:length => 4, :width => 4}
          end

          class Preon < PlanckLength
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = PREON
            ATTRIBUTES = {:length => 3, :width => 3}
          end

          class Quark < Preon
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = QUARK
            ATTRIBUTES = {:length => 4, :width => 4}
          end

          class Neutron < Quark
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            # 2 down and  1 up quark
            TYPE = NEUTRON
          end

          class Proton < Quark
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            # 2 up and 1 down quark
            TYPE = PROTON
          end

          class Atom < Neutron
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = ATOM
          end

          class Atom1 < Proton
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = ATOM1
          end

          class Atom2 < Proton
            include Qed::Mongodb::Test::Factory::ScaleOfUniversClassMixins
            TYPE = ATOM2
          end

          AMOUNT_PLANCK_LENGTHS             = 73
          AMOUNT_NEUTRINOS                  = 67
          AMOUNT_PREONS                     = 57
          AMOUNT_QUARKS                     = 47
          AMOUNT_ELECTRONS                  = 32
          AMOUNT_PROTONS                    = 37
          AMOUNT_NEUTRONS                   = 33
          AMOUNT_ATOMS                      = 21
          AMOUNT_ATOMS1                     = 22
          AMOUNT_ATOMS2                     = 23

          EXAMPLE_UNIVERSE = [
            {:blueprint => PlanckLength,         :amount => AMOUNT_PLANCK_LENGTHS},
            {:blueprint => Neutrino,             :amount => AMOUNT_NEUTRINOS},
            {:blueprint => Preon,                :amount => AMOUNT_PREONS},
            {:blueprint => Quark,                :amount => AMOUNT_QUARKS},
            {:blueprint => Electron,             :amount => AMOUNT_ELECTRONS},
            {:blueprint => Proton,               :amount => AMOUNT_PROTONS},
            {:blueprint => Neutron,              :amount => AMOUNT_NEUTRONS},
            {:blueprint => Atom,                 :amount => AMOUNT_ATOMS},
            {:blueprint => Atom1,                :amount => AMOUNT_ATOMS1},
            {:blueprint => Atom2,                :amount => AMOUNT_ATOMS2}
          ]

          def self.amount_of_objects_in_universe(type)
            type = type.to_sym.downcase

            EXAMPLE_UNIVERSE.each do |bp|
              return bp[:amount] if bp[:blueprint]::TYPE.eql?(type)
            end
          end

          def self.amount_of_types_in_same_dimension(type)
            type = type.to_sym.downcase
            SCALE.each do |s|
              return s.size if s.include?(type)
            end

            raise Exception.new("You provided a type #{type} which doesn't exist in this Universe. I have to raise you")
          end

          EXAMPLE_UNIVERS_PARTICLES = AMOUNT_PLANCK_LENGTHS + AMOUNT_NEUTRINOS + AMOUNT_PREONS + AMOUNT_QUARKS + AMOUNT_ELECTRONS + AMOUNT_PROTONS + AMOUNT_NEUTRONS + AMOUNT_ATOMS + AMOUNT_ATOMS1 + AMOUNT_ATOMS2

          # ========================= WEB PARAMETER =============================================================
          ACTION_NAME_SCALE_OF_UNIVERSE         = "scale_of_universe"

          PARAMS_SCALE_OF_UNIVERSE =
          {
            DRILLDOWN_LEVEL_CURRENT           =>  9999999,
            ACTION                            =>  ACTION_NAME_SCALE_OF_UNIVERSE,
            ACTION_NAME                       =>  ACTION_NAME_SCALE_OF_UNIVERSE,
            CONTROLLER                        =>  CONTROLLER_VALUE
          }
        end
      end
    end
  end
end