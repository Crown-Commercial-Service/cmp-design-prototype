module DataModel


  class DataType
    class << self
      def attribute(name, type, multiplicity = [1..1])
        @attributes = {} unless instance_variable_defined? :@attributes
        @attributes[name] = {:name => name, :type => type, :multiplicity => multiplicity}
        self.define_singleton_method(:attributes) {@attributes}
      end
    end
  end

  class Domain
    def initialize(name)
      @types = {}
    end

    class << self
      def datatype name, &block
        type = self.const_set name, Class.new(DataType)
        @types = {} unless instance_variable_defined? :@types
        @types[name] = type
        self.define_singleton_method(:types) {@types}
        type.instance_exec &block
        type
      end
    end

  end

  module_function
  def domain name, &block
    dom = DataModel.const_set name, Class.new(Domain)
    dom.instance_exec &block
    dom
  end

end # Model
