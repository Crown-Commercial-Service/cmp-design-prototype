require 'test/unit'
require_relative '../src/diagram'
require_relative '../model/agreement'
include DataModel


class DiagramTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  PATH = "out/test/"
  NAME = "d"

  puts __FILE__
  puts

  def setup
    @d = Diagram.new(PATH, NAME)
    if File.file?(@d.dotfile)
      File.delete(@d.dotfile)
    end
  end


  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_dot
    assert_equal("out/test/d.dot", @d.dotfile, "file format")
    assert(!File.file?(@d.dotfile), "no dotfile")
    @d.describe( DataModel::Agreements)
    assert(File.file?(@d.dotfile), "file created")
    assert(File.file?(@d.jpgfile), "file created")

  end
end