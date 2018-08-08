module DataModel

  SINGLE = 1..1
  ONE_TO_MANY = 1..-1
  ZERO_TO_MANY = 0..-1

  class DataType

    class << self

      def init(name, domain, extends)
        @attributes = {}
        @typename = name
        @domain = domain
        @extends = extends

        self.define_singleton_method :domain do
          @domain
        end

        self.define_singleton_method(:attributes) do
          if self.superclass.respond_to? :attributes
            self.superclass.attributes.merge @attributes
          else
            @attributes
          end
        end

      end

      def typename
        @typename
      end

      def attribute(name, type, *args)
        options = {:multiplicity => SINGLE, :description => "", :name => name, :type => type}

        for opt in args
          if opt.is_a? Range
            options[:multiplicity] = opt
          elsif opt.is_a? String
            options[:description] = opt
          elsif opt.is_a? Hash
            options.merge! opt
          else
            raise "last arguments should be string (description), range, or options map, such as :multiplicity => [0..2]:\n " << opt.to_s
          end
        end
        @attributes[name] = options
      end

    end

    attr_reader :name, :attributes

    def initialize(name)
      @name = name
      @attributes = {}
    end


    def method_missing(sym, *args, &block)
      if !block_given? && @attributes[sym]
        return @attributes[sym]
      end
      if self.class.attributes[sym]
        if self.class.attributes[sym][:multiplicity] != SINGLE
          @attributes[sym] = [] unless @attributes[sym]
          @attributes[sym] << valueof(sym, *args, &block)
        else
          @attributes[sym] = valueof(sym, *args, &block)
        end
        return @attributes[sym]
      end
      puts "Warning: unknown attribute #{sym}?"
    end

    def to_s
      "#{self.class.typename} #{self.name} #{@attributes}"
    end

    private

    def valueof(sym, *args, &block)
      if self.class.attributes[sym][:type] < DataType
        at = self.class.attributes[sym][:type].new(self.class.attributes[sym][:name])
        if nil == block
          raise "Need a block for a nested type #{sym}"
        end
        at.instance_exec &block
        return at
      else
        args[0]
      end
    end

  end

  class Domain

    class << self
      def datatype(name, extends = DataType, &block)
        @types = {} unless instance_variable_defined? :@types
        if extends.class != Class
          extends = @types.fetch(extends, DataType)
        end
        type = self.const_set name, Class.new(extends)
        # puts "defined #{type} from #{name} on #{self }"
        @types[name] = type
        self.define_singleton_method(:types) {@types}
        dom = self
        type.instance_exec do
          init name, dom, extends
        end
        type.instance_exec &block
        type
      end

    end

    attr_reader :contents, :name

    def initialize name, &block
      @contents = {}
      @name = name
      self.class.const_set name, self
      self.instance_exec &block
    end

    def method_missing(sym, &block)
      # create a new datatype for each matching type name, and run its block
      for t in self.class.types.values
        if t.typename.downcase == sym
          decl = t.new(sym)
          @contents[sym] = [] unless @contents[sym]
          @contents[sym] << decl
          decl.instance_exec &block
          return decl
        end
      end
      puts "Warning unknown type #{sym} ignored"
    end

  end


  module_function

  def domain(name, &block)
    dom = Object.const_set name, Class.new(Domain)
    dom.instance_exec &block
    return dom
  end


end # DataModel
