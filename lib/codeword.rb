class Codeword

  DICT_PATH = File.join(__dir__, "../dictionary/5desk.txt")
  SAVED_GAMES_PATH = File.expand_path("../../saved_games", __FILE__)

  attr_reader :codeword, :guesses, :correct_guesses

  def initialize(game={})
    @words = File.readlines(DICT_PATH)

    if game.empty?
      set_new_codeword
    else
      load_codeword(game)
    end

  end

  def set_new_codeword()
    @codeword = create_codeword
    @letters = @codeword.split("")
    @guesses = []
    @correct_guesses = []
  end

  def load_codeword(game)
    @codeword = game["codeword"]
    @letters = @codeword.split("")
    @guesses = game["guesses"]
    @correct_guesses = game["correct_guesses"]
  end

  def take_guess(guess)
    @guesses.append(guess)

    # compare with word and return true if
    # the letter is in the word
    if @letters.include?(guess)
      @correct_guesses << guess
      true
    else
      false
    end
  end

  # returns true if the word was guessed
  def guessed?()
    if @letters - @guesses == []
      true
    else
      false
    end
  end

  def to_s()
    # FIXME debug stuff
    # puts
    # puts "============================="
    # p "@letters: #{@letters}"
    # puts
    # p "@guesses: #{@guesses}"
    # puts
    # p "@correct_guesses: #{@correct_guesses}"
    # puts "============================="

    # create the string and reveal already guessed letters
    string = ""
    @letters.each do |letter|
      if @correct_guesses.include?(letter)
        string << letter
      else
        string << "_"
      end
    end

    alphabet = ""
    # use the colorize gem if it is loaded
    if defined?(String.colors)
      ('A'..'Z').each do |letter|
        if @correct_guesses.include?(letter.downcase)
          alphabet << letter.colorize(:green)
        elsif @guesses.include?(letter.downcase)
          alphabet << letter.colorize(:red)
        else
          alphabet << letter
        end
      end
    end

    return string.center(24) + alphabet + "\n\n"
  end


  def show()
    puts @codeword.center(24)
  end

  private

  def create_codeword()
    # select a codeword and repeat until the length is between 5 and 12
    # characters or is an uppercase word
    begin
      codeword = @words.sample.chomp
    end while
    (codeword.length < 5 or codeword.length > 12 or codeword[0] == codeword[0].upcase)

    # FIXME remove after the debugging is done
    puts codeword

    return codeword
  end
end
