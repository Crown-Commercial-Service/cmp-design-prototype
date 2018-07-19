module DataModel


  class DataType
    class << self
      def attribute(name, type, multiplicity = [1..1])
        @attributes = {} unless instance_variable_defined? :@attributes
        @attributes[name] = {:name => name, :type => type, :multiplicity => multiplicity}
        # add a class level accessor to get the attributes
        self.define_singleton_method(:attributes) do
          if self.superclass.respond_to? :attributes
            self.superclass.attributes.merge @attributes
          else
            @attributes
          end
        end
      end
    end
  end

  class Domain
    def initialize(name)
      @types = {}
    end

    class << self
      def datatype name, extends = DataType, &block
        @types = {} unless instance_variable_defined? :@types
        if (nil != extends && extends.class != Class) then
          extends = @types.fetch(extends, DataType)
        end
        type = self.const_set name, Class.new(extends)
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
