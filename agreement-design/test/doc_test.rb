require 'test/unit'
require_relative '../src/doc'
require_relative 'test_model'
include DataModel

class DocTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  PATH = "out/test/"
  NAME = "doctest"
  META = "modeldoctest"

  def setup
    @d = Document.new(PATH, NAME)
    if File.file?(@d.filepath)
      File.delete(@d.filepath)
    end
    @m = Document.new(PATH, META)
    if File.file?(@d.filepath)
      File.delete(@d.filepath)
    end
  end

  def test_dot
    assert_equal("#{PATH}doc/#{NAME}.md", @d.filepath, "file name")
    assert(!File.file?(@d.filepath), "no dotfile")
    @d.document( TestModel::TESTMODEL)
    assert(File.file?(@d.filepath), "file created")
    @m.document_metamodel( TestModel)
    assert(File.file?(@m.filepath), "file created")
  end
end