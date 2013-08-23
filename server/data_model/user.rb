require 'mongoid'

module DataModel
  class User
    include Mongoid::Document

    field :name
  end
end
