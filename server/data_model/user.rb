require 'mongoid'

module Deathmatch::DataModel
  class User
    include Mongoid::Document

    field :name
  end
end
