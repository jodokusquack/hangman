class Game

  SAVED_GAMES_PATH = File.expand_path("../../saved_games", __FILE__)
  MAX_GUESSES = 10

  def initialize()
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
    print "
Do you want to load a saved game or start a new one?

[n]     Start a new game

[d]     Delete a saved game

"
    options = ["n", "d"]
    options += display_saved_games(saved_games)

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
      return "new"
    elsif option == "d"
      # delete a game
      delete_game(saved_games)
      # then call ask_to_load_game again and return the output of the
      # next call
      return ask_to_load_game
    else
      puts "Starting game ##{option}!"
      return "save_#{option}.json"
    end
  end

  def display_saved_games(saved_games)
    options = []
    # print all saved games as options for the player
    saved_games.each do |file|
      number = File.basename(file, ".json").split("_")[1]
      print "[#{number}]     #{File.atime(File.join(SAVED_GAMES_PATH, file)).strftime("Created at: %c")}"
    puts
    puts
      # add the number to the possible options
      options << number.to_s
    end

    return options
  end

  def delete_game(list_of_saves)
    puts "Which save do you want to delete?"
    puts
    options = display_saved_games(list_of_saves)

    begin
      puts "Select one of the options above."
      option = gets.chomp.downcase
      puts "================================"
      puts
      raise IOError if !options.include? option
    rescue IOError
      retry
    end

    File.delete(File.join(SAVED_GAMES_PATH, "save_#{option}.json"))
    puts "Deleted Game ##{option}."
  end

  def save_game()
    #create a hash of the current state
    save_state = {
      codeword: @codeword.codeword,
      guesses: @codeword.guesses,
      correct_guesses: @codeword.correct_guesses,
    }

    #create an array of already existing saved games
    saved_games = Dir.glob("*.json", base: SAVED_GAMES_PATH)

    #if there are already 3 saved games,
    #overwrite one
    if saved_games.length == 3
      puts "You can only save 3 games at a time."
      puts "Which game do you want to overwrite? (Enter any non-number to cancel)"
      num = gets.chomp.downcase

      if !!/\A\d+\z/.match(num)
        file_name = "save_#{num.to_s}.json"
      else
        puts "Cancelled."
        return
      end
    else
      # if there are less than 3 games
      # saved, find the next free number
      (1..3).each do |num|
        if saved_games.include?("save_#{num}.json")
          next
        end
        file_name = "save_#{num}.json"
        break
      end
    end
    # save the object to a file
    file_path = File.join(SAVED_GAMES_PATH, file_name)
    File.write(file_path, JSON.generate(save_state))

    puts "Saved as Game ##{File.basename(file_path, ".json").split("_")[1]
}"
    puts
  end

  def setup(player_name, file)
    # create @player and @codeword either new or from a saved_game
    if file == 'new'
      puts "Starting a new game!"

      @player = Player.new(player_name)
      @codeword = Codeword.new()

      # reset the number of guesses
      @guesses_left = MAX_GUESSES
    else
      file_contents = File.read(File.join(SAVED_GAMES_PATH, file))
      game = JSON.parse(file_contents)
      @player = Player.new(player_name, game["guesses"])
      @codeword = Codeword.new(game)

      @guesses_left =
        MAX_GUESSES - game["guesses"].length + game["correct_guesses"].length
    end

  end

  def play_round()

    while @guesses_left > 0
      # print codeword to screen
      puts @codeword.to_s

      puts "Guesses left: #{@guesses_left}"

      # get the player guess and check if game should be saved
      guess = @player.guess
      if guess == 'save'
        save_game

        # ask the player if he/she wants to continue
        puts "Do you want to continue playing? [y/N]"

        ans = gets.chomp.downcase
        if ans[0] == "y"
          next
        else
          abort "Thanks for playing"
        end
      else
        result = @codeword.take_guess(guess)
      end

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
