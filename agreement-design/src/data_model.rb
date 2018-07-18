module DataModel

  module_function

  def datamodel cls
    # Open the class argument so we can add class methods to it.
    # Here we add all the model capabilities we want
    class << cls
      # in `cls` eigenclass scope, methods we define become eigenclass methods that can be called in the definition
      # block of cls.
      def attribute(name, type, multiplicity = [1..1])
        @attributes = {} unless instance_variable_defined? :@attributes
        @attributes[name] = {:name => name, :type => type, multiplicity => multiplicity}
        puts @attributes
        puts self
        # Add a getter to the class. We have to do this in the class method to apply it to
        # get a map of the attribute by name
        self.define_singleton_method(:attributes) {@attributes}
      end
    end
  end

  # eigenclass scope

  class DataType
    DataModel::datamodel self
  end

end # Model

class T < DataModel::DataType
end