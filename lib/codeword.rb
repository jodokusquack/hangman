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

    # compare with word here
    
    
    puts "The guess was #{guess}"
  end

  def guessed?()
    if @letters - @guesses == []
      true
    else
      false
    end
  end

  private
  def create_codeword()

    begin
      codeword = @words.sample
    end while 
    (codeword.length < 5 or codeword.length > 12)

    puts codeword

    return codeword

  end
end
