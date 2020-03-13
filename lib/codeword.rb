class Codeword

  DICT_PATH = File.join(__dir__, "../dictionary/5desk.txt")
  def initialize()
    @words = File.readlines(DICT_PATH)
  end

  def set_new_codeword()
    @codeword = create_codeword
    @letters = @codeword.split("")
    @guesses = []
    @correct_guesses = []
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
    # debug stuff
    puts
    puts "============================="
    p "@letters: #{@letters}"
    puts
    p "@guesses: #{@guesses}"
    puts
    p "@correct_guesses: #{@correct_guesses}"
    puts "============================="

    # create the string each time 
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

    return string.center(24) + alphabet
  end

  private
  def create_codeword()

    begin
      codeword = @words.sample.chomp
    end while 
    (codeword.length < 5 or codeword.length > 12)

    puts codeword

    return codeword

  end
end
