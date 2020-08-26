require 'securerandom'

module Helpers

  class EndwareRandomUUID
    attr_reader(:uuid)

    def initialize
      @uuid = SecureRandom.uuid
    end

    def call(env)
      uuid
    end
  end

  class Endware
    def call(env)
      nil
    end
  end

  def self.endware_that_returns_random_uuid_on_call
    EndwareRandomUUID.new
  end

  def self.endware_that_responds_to_call
    Endware.new
  end
end