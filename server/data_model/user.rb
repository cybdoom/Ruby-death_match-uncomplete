require 'mongoid'

module Deathmatch
  module DataModel
    class User
      include Mongoid::Document

      field :name
    end
  end
end
