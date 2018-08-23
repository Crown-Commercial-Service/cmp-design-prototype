require 'test/unit'
require_relative '../src/data'
require_relative 'test_model'
include DataModel

class DataTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  PATH = "out/test/"
  NAME = "datatest"

  def setup
    @d = DataFile.new(PATH, NAME)
    if File.file?(@d.filepath)
      File.delete(@d.filepath)
    end
  end

  def test_dot
    assert_equal("#{PATH}data/#{NAME}.json", @d.filepath, "file name")
    assert(!File.file?(@d.filepath), "no dotfile")
    @d.output( TestModel::TESTMODEL)
    assert(File.file?(@d.filepath), "file created")
  end
end