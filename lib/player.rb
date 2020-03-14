class Player
  LETTERS = ('a'..'z').to_a

  def initialize(name, guesses=[])
    @name = name
    @guesses = guesses
  end

  def guess()
    puts "Your guess: "
    guess = gets.chomp.downcase

    # special case that you want to save
    # the game
    if guess == 'save'
      return guess
    end

    # consider that the player can enter
    # something else than expected...
    if !LETTERS.include?(guess) or @guesses.include?(guess)
      validated = false
      while validated == false
        puts "Please enter a single letter that you haven't used before."
        guess = gets.chomp.downcase
        if LETTERS.include?(guess) and !@guesses.include?(guess)
          validated = true
        end
      end 
    end
    
    @guesses << guess

    return guess

  end
end
