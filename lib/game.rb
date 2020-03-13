class Game

  def inititalize()
  end

  def play()
    system "clear"
    @player = create_player
    @codeword = create_codeword

    continue = true
    while continue == true
      system "clear"
      play_round
      continue = continue?
    end
  end

  private

  def create_player()
    puts "Who is playing?"
    name = gets.chomp 
    if name == ""
      name = "Jakob"
    end
    player = Player.new(name)
    puts "Setting up a game for #{name}"

    return player
  end

  def create_codeword()
    return Codeword.new()
  end

  def play_round()
    @codeword.set_new_codeword

    guesses_left = 10

    while guesses_left > 0

      @codeword.take_guess(@player.guess)
      break if @codeword.guessed?

      guesses_left -= 1
    end
  end

  def continue?
    puts "Do you want to play another round? [Y/n]"
    input = gets.chomp.downcase

    if ["n", "q", "e"].include? input[0]
      false
    else
      true
    end
  end
end
