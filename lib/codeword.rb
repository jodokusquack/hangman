class Codeword

  DICT_PATH = File.join(__dir__, "../dictionary/5desk.txt")
  SAVED_GAMES_PATH = File.expand_path("../../saved_games", __FILE__)

  def initialize()
    @words = File.readlines(DICT_PATH)

    # check if the SAVED_GAMES dir exists
    if !Dir.exist?(SAVED_GAMES_PATH)
      Dir.mkdir(SAVED_GAMES_PATH)
    end

  end

  def set_new_codeword()
    @codeword = create_codeword
    @letters = @codeword.split("")
    @guesses = []
    @correct_guesses = []
  end

  def take_guess(guess)
    # special case if the player wants to save
    if guess == 'save'
      puts "Saving game"
      self.save
      puts "Saved!"
      return 'save'
    end

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
    # REMOVE debug stuff
    puts
    puts "============================="
    p "@letters: #{@letters}"
    puts
    p "@guesses: #{@guesses}"
    puts
    p "@correct_guesses: #{@correct_guesses}"
    puts "============================="

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

    return string.center(24) + alphabet
  end

  def save()
    #create a hash of the current state
    word = {
      codeword: @codeword,
      guesses: @guesses
    }

    #create an array of already existing saved games
    saved_games = Dir.glob("*.json", base: SAVED_GAMES_PATH)
    puts saved_games
    # create a file for the data


    #if there are already 3 saved games,
    #overwrite one
    if saved_games.length == 3
      puts "You can only save 10 games at a time."
      puts "Which game do you want to overwrite? (Enter any non-number to cancel)"
      num = gets.chomp.downcase

      if num.is_a?(Integer)
        file_name = "save_#{num}.json"
      end
    else
      # if there are less than 10 games
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
    File.open(file_path, 'w') do |file|
      file.puts word.to_json
    end
    puts "Wrote to file #{file_path}"
  end

  private

  # FIXME Skip words that are capitalized!!! Because you can't guess
  # uppercase letters
  def create_codeword()
    # select a codeword and repeat until the length is between 5 and 12
    # characters
    begin
      codeword = @words.sample.chomp
    end while 
    (codeword.length < 5 or codeword.length > 12)

    # REMOVE after the debugging is done
    puts codeword

    return codeword
  end
end
