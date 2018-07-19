module DataModel


  class DataType
    SINGLE = 1..1
    ONE_TO_MANY = 1..-1
    ZERO_TO_MANY = 0..-1

    class << self

      def attribute(name, type, *args)
        options = {:multiplicity => SINGLE, :description => "", :name => name, :type => type}

        for opt in args
          if opt.is_a? Range
            options[:multiplicity]= opt
          elsif opt.is_a? String
            options[:description]= opt
          elsif opt.is_a? Hash
            options.merge! opt
          else
            raise "last arguments should be string (description), range, or options map, such as :multiplicity => [0..2]:\n " << opt.to_s
          end
        end

        # multiplicity = 1..1])
        @attributes = {} unless instance_variable_defined? :@attributes
        @attributes[name] = options

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
