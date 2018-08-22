require 'date'

module DataModel

  SINGLE = 1..1
  ONE_TO_MANY = 1..-1
  ZERO_TO_MANY = 0..-1
  ZERO_OR_ONE = 0..1

  class DataType

    class << self

      def init(name, domain, extends, description)
        @attributes = {}
        @typename = name
        @domain = domain
        @extends = extends
        @description = description

        self.define_singleton_method :domain do
          @domain
        end
        self.define_singleton_method :description do
          @description
        end

        self.define_singleton_method(:attributes) do |inherited = true|
          if inherited && self.superclass.respond_to?(:attributes)
            self.superclass.attributes.merge @attributes
          else
            @attributes
          end
        end

      end

      def typename
        @typename
      end

      def extends
        @extends < DataType ? @extends.name : nil
      end

      def attribute(name, type, *args, multiplicity: SINGLE, description: "", links: nil)
        type = getType(type)
        options = {:multiplicity => multiplicity, :description => description, :name => name, :type => type}
        options[:links] = getType(links)

        for opt in args
          if opt.is_a? Range
            options[:multiplicity] = opt
          elsif opt.is_a? String
            options[:description] = opt
          else
            raise "optional arguments should be string (description), or range\n " << opt.to_s
          end
        end

        @attributes[name] = options
      end

      private

      def getType(typeref)
        domain.getType typeref
      end

    end

    attr_reader :name, :attributes

    def initialize(name, attributes = {}, &block)
      @name = name
      @attributes = attributes

      self.class.attributes.keys.each do |k|
        # add a definition / accessor for each attribute
        self.define_singleton_method(k) do |*args, &block|
          if args.length == 0 && !block
            unless @attributes[k]
              puts ("Warning - reading unset attribute '#{k}' on #{self.class}")
            end
            return @attributes[k]
          end
          if self.class.attributes[k][:multiplicity] != SINGLE
            @attributes[k] = [] unless @attributes[k]
            @attributes[k] << valueof(k, *args, &block)
          else
            @attributes[k] = valueof(k, *args, &block)
          end
          return @attributes[k]
        end
      end

      if block_given?
        self.instance_exec &block
      end
    end

    def to_s
      "#{self.class.typename} #{self.name} #{@attributes}"
    end

    private

    def valueof(sym, *args, &block)
      if self.class.attributes[sym][:type] < DataType
        at = self.class.attributes[sym][:type].new(self.class.attributes[sym][:name])
        if nil == block
          raise "Need a block for a nested type #{sym} in #{self}"
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
      def datatype(name, extends: DataType, description: "", &block)
        unless instance_variable_defined? :@types
          @types = {}
          self.define_singleton_method(:types) {@types}
        end
        extends = getType(extends)
        type = self.const_set name, Class.new(extends)
        @types[name] = type
        dom = self
        type.instance_exec do
          init name, dom, extends, description
        end
        type.instance_exec &block
        type
      end

      def getType(typeref)
        if !typeref
          return nil
        end
        if typeref.class == Symbol
          if !types[typeref]
            raise "Can't find type #{typeref} in #{typeref}"
          end
          return types[typeref]
        elsif typeref.class == Class
          return typeref
        else
          raise "type refs must be symbol or DataType class"
        end
      end

      def comment( *context,
                 description: nil, title: nil, uri: nil)
        unless instance_variable_defined? :@comments
          @comments = {}
          self.define_singleton_method(:comments) {@comments}
        end
        @comments["#{context.join'.'}"] = {:description => description, :title => title, :uri => uri}
      end

    end

    attr_reader :contents, :name

    def initialize name, &block
      @contents = {}
      @name = name
      self.class.const_set name, self

      self.class.types.values.each do |t|
        # add a definition / accessor for each type
        k = t.typename.downcase
        self.define_singleton_method(k.to_sym) do |*args, &block|
          if args.length == 0 && !block
            unless @contents[k]
              raise("reading unset type decl #{k} on #{self}")
            end
            return @contents[k]
          end
          decl = t.new(k)
          @contents[k] = [] unless @contents[k]
          @contents[k] << decl
          if block_given?
            decl.instance_exec &block
          else
            puts "warning: no block given for type #{k} in #{self}"
          end
          return decl
        end

      end

      self.instance_exec &block
    end

  end


  module_function

  def domain(name, &block)
    dom = Object.const_set name, Class.new(Domain)
    dom.instance_exec &block
    return dom
  end

  module_function

  def date(day, month, year)
    Date.new(day, month, year)
  end

  def Selection(*args)
    typename = "Selection_#{args.join '_'}"
    selclass = Object.const_set typename, Class.new(Symbol)
    selclass.define_singleton_method(:selection) {args}
    selclass.define_singleton_method(:validate) {|s| selection.member? s.to_sym}
    selclass.define_singleton_method(:to_s) {"(#{self.selection.join(',')})"}
    return selclass
  end

end # DataModel
