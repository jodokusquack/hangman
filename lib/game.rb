class Game

  SAVED_GAMES_PATH = File.expand_path("../../saved_games", __FILE__)
  MAX_GUESSES = 10

  def inititalize()
    # check if the SAVED_GAMES dir exists or create it of not
    if !Dir.exist?(SAVED_GAMES_PATH)
      Dir.mkdir(SAVED_GAMES_PATH)
    end
  end

  def play()
    begin
      name = ask_player_name
      display_rules(name)

      continue = true
      while continue == true
        # ask first if a game should be loaded if one exists
        file = ask_to_load_game
        # create the @player and @codeword in setup
        setup(name, file)
        # play the actual game with the player and keyword
        play_round()
        # ask for another round
        continue = continue?
      end
    rescue Interrupt
      abort "Thanks for playing"
    end
  end

  private

  def display_rules(name)
    puts "
OK #{name}! These are the rules:
You have to guess the secret word before your guesses run out. You can guess any letter and if it is contained in the secret word it will be revealed.

If at any point you get called to the dinner table or have to save the game for any other reason, you can type 'save' and can continue playing, the next time you start the game up.
Now, have fun and don't get hanged!"
    puts
  end

  def ask_player_name()
    puts "Who is playing?"
    name = gets.chomp 
    if name == ""
      name = "Jakob"
    end

    return name
  end

  def ask_to_load_game()
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
      print "[#{number}]     #{File.atime(File.join(SAVED_GAMES_PATH, file)).strftime("Created at: %c")}"
    puts
    puts
      # add the number to the possible options
      options << number.to_s
    end

    begin
      puts "Select one of the options above."
      option = gets.chomp.downcase
      puts "================================"
      puts
      raise IOError if !options.include? option
    rescue IOError
      retry
    end

    if option == "n"
      puts "Starting a new game!"
      return "new"
    else
      puts "Starting game ##{option}!"
      return "save_#{option}.json"
    end
  end

  # TODO move save function to the Game class
  def setup(player_name, file)
    # create @player and @codeword either new or from a saved_game
    if file == 'new'
      @player = Player.new(player_name)
      @codeword = Codeword.new()

      # reset the number of guesses
      @guesses_left = MAX_GUESSES
    else
      file_contents = File.read(File.join(SAVED_GAMES_PATH, file))
      game = JSON.parse(file_contents)

      @player = Player.new(player_name, game["guesses"])
      @codeword = Codeword.new(game)

      @guesses_left = MAX_GUESSES - game["guesses"].length
    end

  end

  def play_round()

    while @guesses_left > 0
      # print codeword to screen
      puts @codeword.to_s

      puts "Guesses left: #{@guesses_left}"
      result = @codeword.take_guess(@player.guess)

      # end the game if the word was guessed
      break if @codeword.guessed?

      @guesses_left -= 1 if result == false
    end

    if @guesses_left == 0
      puts "---------------------------------"
      puts "Oh no, you lost! :( The word was:"
      @codeword.show
      puts
    else
      puts "++++++++++++++++++++++++++++"
      puts "Congratulations! You won! :)"
      puts
      @codeword.show
      puts
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
