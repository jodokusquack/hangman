class Game

  def inititalize()
  end

  def play()
    continue = true
    while continue == true
      system "clear"
      start_round
      play_round
      continue = continue?
    end
  end

  private

  def start_round()
    #@player = create_player
    #@secret_word = create_secret_word
    puts "Setting up a game..."
  end

  def play_round()
    puts "Playing the game. In my head..."
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
