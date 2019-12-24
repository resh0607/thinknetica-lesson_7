module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instance_counter

    def instances
      @instance_counter.nil? ? 0 : @instance_counter
    end
  end

  module InstanceMethods

    protected

    def register_instance
      self.class.instance_counter ||= 0
      self.class.instance_counter += 1
    end
  end
end