class Game

  SAVED_GAMES_PATH = File.expand_path("../../saved_games", __FILE__)
  MAX_GUESSES = 10

  def inititalize()
  end

  def play()
    begin
      @player = create_player
      @codeword = create_codeword

      continue = true
      while continue == true
        # ask first if a game should be loaded if one exists
        mode = load_game
        play_round(mode)
        # ask for another round
        continue = continue?
      end
    rescue Interrupt
      abort "Thanks for playing"
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
    puts "
OK #{name}! These are the rules:
You have to guess the secret word before your guesses run out. You can guess any letter and if it is contained in the secret word it will be revealed.

If at any point you get called to the dinner table or have to save the game for any other reason, you can type 'save' and can continue playing, the next time you start the game up.
Now, have fun and don't get hanged!"
    puts


    return player
  end

  def create_codeword()
    return Codeword.new()
  end

  def load_game()
    saved_games = Dir.glob("*.json", base: SAVED_GAMES_PATH)
    if saved_games.length == 0 
      return 'new'
    end

    # create an array for all possible options of the player
    options = ["n"]
    print "
    Do you want to load a saved game or start a new one?

    [n]     Start a new game
    "
    # print all saved games as options for the player
    saved_games.each do |file|
      number = File.basename(file, ".json").split("_")[1]
      print "
    [#{number}]     #{File.atime(File.join(SAVED_GAMES_PATH, file)).strftime("Created at: %c")}"
    puts
      # add the number to the possible options
      options << number.to_s
    end

    begin
      puts "Select one of the options above."
      option = gets.chomp.downcase
      raise IOError if !options.include? option
    rescue IOError
      retry
    end

    if option == "n"
      return "new"
    else
      return "save_#{option}.json"
    end
  end

  def play_round(file)
    if file == 'new'
      @codeword.set_new_codeword
      guesses_left = MAX_GUESSES
    else
      # loading the codeword should return how many guesses were already
      # made
      guesses = @codeword.load(file)
      guesses_left = MAX_GUESSES - guesses
    end


    while guesses_left > 0
      puts "Guesses left: #{guesses_left}"

      result = @codeword.take_guess(@player.guess)
      puts @codeword.to_s
      break if @codeword.guessed?

      guesses_left -= 1 if result == false
    end

    # TODO Add the show function to the codeword
    if guesses_left == 0
      puts "The word was:"
      @codeword.show
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
