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

  def self.class_includes_modules(class_name, *modules_to_be_mixed_in)
    modules_mixed_in_by_class = class_name.included_modules

    modules_to_be_mixed_in.all? do |module_name|
      modules_mixed_in_by_class.include?(module_name)
    end
  end
end