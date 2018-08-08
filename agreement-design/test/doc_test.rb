require 'test/unit'
require_relative '../src/doc'
require_relative '../model/fm'
include DataModel

class DocTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  PATH = "out/test/"
  NAME = "doctest"

  def setup
    @d = Doc.new(PATH, NAME)
    if File.file?(@d.docfile)
      File.delete(@d.docfile)
    end
  end


  def test_dot
    assert_equal("out/test/diagrams/d.dot", @d.dotfile, "file format")
    assert_equal("out/test/images/d.jpg", @d.jpgfile, "file format")
    assert(!File.file?(@d.dotfile), "no dotfile")
    @d.describe( DataModel::Category)
    assert(File.file?(@d.dotfile), "file created")
    assert(File.file?(@d.jpgfile), "file created")
    # TODO test the features in the diagram
    @d.describe( DataModel::Category, DataModel::Parties)
  end
end