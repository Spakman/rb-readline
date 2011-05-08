require 'test/unit'
require 'readline'
require "#{File.expand_path(File.dirname(__FILE__))}/filesystem_completion_helper"

class TC_FILENAME_COMPLETION_PROC < Test::Unit::TestCase
  include FilesystemCompletionHelper

  def setup
    setup_filesystem_for_completion
  end

  def teardown
    teardown_filesystem_after_completion
  end

  def test_listing_files_in_cwd
    Dir.chdir(COMP_TEST_DIR) do
      entries = Dir.entries(".").select { |e| e[0,1] == "a" }
      assert_equal entries, Readline::FILENAME_COMPLETION_PROC.call("a")
    end
  end

  def test_list_files_in_sub_directories
    entries = @sub_dir.entries.select { |e| e[0,1] == "a" }
    entries.map! { |e| @sub_dir.path + e }
    assert_equal entries, Readline::FILENAME_COMPLETION_PROC.call("#{@sub_dir.path}a")

    entries = @sub_sub_dir.entries - %w( . .. )
    entries.map! { |e| @sub_sub_dir.path + e }
    assert_equal entries, Readline::FILENAME_COMPLETION_PROC.call(@sub_sub_dir.path)
  end

  def test_list_files_and_directories_with_spaces
    entries = @comp_test_dir.entries.select { |e| e[0,1] == "d" }
    entries.map! { |e| @comp_test_dir.path + e }
    assert_equal entries, Readline::FILENAME_COMPLETION_PROC.call("#{@comp_test_dir.path}d")

    entries = @dir_with_spaces.entries - %w( . .. )
    entries.map! { |e| @dir_with_spaces.path + e }
    assert_equal entries, Readline::FILENAME_COMPLETION_PROC.call("#{@dir_with_spaces.path}")
  end
end
