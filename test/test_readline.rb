require 'test/unit'
require 'readline'

class TC_Readline < Test::Unit::TestCase
   def setup
      @proc = proc{ |s| ['alpha', 'beta'].grep( /^#{Regexp.escape(s)}/) }
   end

   def test_version
      assert_equal('5.2', Readline::VERSION)
   end
   
   def test_readline_basic
      assert_respond_to(Readline, :readline)      
   end
   
   def test_readline_expected_errors
      assert_raise(ArgumentError){ Readline.readline }
   end

   def test_input_basic
      assert_respond_to(Readline, :input=)
   end

   def test_input
      assert_nothing_raised{ Readline.input = $stdin }
   end

   def test_output_basic
      assert_respond_to(Readline, :output=)
   end

   def test_output
      assert_nothing_raised{ Readline.output = $stdout }
   end

   def test_completion_proc_get_basic
      assert_respond_to(Readline, :completion_proc)
   end

   def test_completion_proc_set_basic
      assert_respond_to(Readline, :completion_proc=)
   end

   def test_completion_proc
      assert_nothing_raised{ Readline.completion_proc = @proc }
   end

   def test_completion_case_fold_get_basic
      assert_respond_to(Readline, :completion_case_fold)
   end

   def test_completion_case_fold_default
      assert_equal(false, Readline.completion_case_fold) # default
   end

   def test_completion_case_fold_set_basic
      assert_respond_to(Readline, :completion_case_fold=)
   end

   def test_completion_case_fold_changed
      assert_nothing_raised{ Readline.completion_case_fold = false }
   end

   def test_completion_proc_expected_errors
      assert_raise(ArgumentError){ Readline.completion_proc = 1 }
      assert_raise(ArgumentError){ Readline.completion_proc = 'a' }
   end

   def test_vi_editing_mode_basic
      assert_respond_to(Readline, :vi_editing_mode)
   end

   def test_emacs_editing_mode_basic
      assert_respond_to(Readline, :emacs_editing_mode)
   end

   def test_completion_append_character_get_basic
      assert_respond_to(Readline, :completion_append_character)
   end

   def test_completion_append_character_get
      assert_equal(' ', Readline.completion_append_character) # default
   end

   def test_completion_append_character_set_basic
      assert_respond_to(Readline, :completion_append_character=)
   end

   def test_completion_append_character_set
      assert_nothing_raised{ Readline.completion_append_character }
   end

   def test_basic_word_break_characters_get_basic
      assert_respond_to(Readline, :basic_word_break_characters)
   end

   def test_basic_word_break_characters_get
      assert_equal(" \t\n\"\\'`@$><=|&{(", Readline.basic_word_break_characters)
   end

   def test_basic_word_break_characters_set_basic
      assert_respond_to(Readline, :basic_word_break_characters=)
   end

   def test_basic_word_break_characters_set
      assert_nothing_raised{ Readline.basic_word_break_characters = " \t\n\"\\'`@$><=|&{(" }
   end

   def test_basic_quote_characters_get_basic
      assert_respond_to(Readline, :basic_quote_characters)
   end

   def test_basic_quote_characters_get
      assert_nothing_raised{ Readline.basic_quote_characters }
      assert_equal("\"'", Readline.basic_quote_characters)
   end

   def test_basic_quote_characters_set_basic
      assert_respond_to(Readline, :basic_quote_characters=)
   end

   def test_basic_quote_characters_set
      assert_nothing_raised{ Readline.basic_quote_characters = "\"'" }
   end

   def test_attempted_comp_func_returns_nil_when_no_completion_proc_set
     assert_equal nil, Readline.readline_attempted_completion_function("12", 0, 1)
   end

   def test_attempted_comp_func_case_folding
     Readline.completion_proc = Proc.new do |word|
       %w( 123456 123abc abc123 ).grep(/^#{word}/i)
     end

     Readline.completion_case_fold = true

     assert_equal [ "123", "123456", "123abc", nil ], Readline.readline_attempted_completion_function("123", 0, 3)

     assert_equal [ "123abc", nil, nil ], Readline.readline_attempted_completion_function("123A", 0, 3)

   ensure
     Readline.module_eval do
       @completion_proc = nil
     end
     Readline.completion_case_fold = false
   end

   def test_attempted_comp_func_removes_replacement_from_possible_matches
     Readline.completion_proc = Proc.new do |word|
       %w( 123456 123abc abc123 ).grep(/^#{word}/)
     end

     assert_equal [ "123", "123456", "123abc", nil ], Readline.readline_attempted_completion_function("12", 0, 1)

     assert_equal [ "123", "123456", "123abc", nil ], Readline.readline_attempted_completion_function("123", 0, 2)

     assert_equal [ "123456", nil, nil ], Readline.readline_attempted_completion_function("1234", 0, 3)

   ensure
     Readline.module_eval do
       @completion_proc = nil
     end
   end

   def teardown
      @proc = nil
   end
end
