#+--------------------------+
#|\Project 4  ||project4.rb/|
#|            ||            |
#|           #++#           |
#+-    The Crimson King    -+
#|           #++#           |
#|            ||   James    |
#|/           ||Miners-Webb\|
#+--------------------------+

def clear
  print "\e[H\e[2J"
end

clear

require_relative "proj4_concepts"

class Location
  attr_reader :name, :rooms
  attr_accessor :name, :rooms

  def initialize(name)
    @name = name
    @rooms = Array.new
  end

  def showRooms
    @rooms.each do |i|
      puts "#{i.about}"
    end
  end

  def addRoom(amount)
    colors = ["red","blue","yellow","green","orange","black","gold"]
    smells = ["daisies","old meat","a rotting carcass","a pleasent perfume","baked apple pie","old rotten blood","spilled beer"]
    sounds = ["whispering voices","intermittent screaming from no particular direction","absolute silence","a ticking clock","dripping water"]

    descriptors = ["A room","An area","A library","An armory","A sleeping area","A storage area","An empty room","A kitchen"]
    descriptors1 = ["feint smell of #{smells.sample}","an overpowering smell of #{smells.sample}","drawings on the walls","a strange #{colors.sample} goo on the floor",
            "#{colors.sample} baskets on the ground","dead bodies everywhere","bodies on the floor","the sound of #{sounds.sample}","sharp sticks hanging from the ceiling"]

    amount.times do
      @rooms << Room.new("Cavern #{rand(1..99)} #{colors.sample}","#{descriptors.sample} with #{descriptors1.sample}",rand(1..7))
    end

  end

  def deleteRoom(room)
    @rooms.slice!(room)
  end
end

class Room
  attr_reader :name, :connections, :choices, :searched, :loot, :enc_chance, :encounter
  attr_accessor :name, :connections, :choices, :searched, :loot, :enc_chance, :encounter


  def initialize(name,description,enc_chance)
    @name = name
    @description = description
    @connections = Array.new
    @choices = ["Change location","Search","Use item","Show info"]
    @searched = false
    @loot = Array.new
    @enc_chance = enc_chance

    if @enc_chance * rand(1..10) >= 40
      @encounter = Encounter.new("Group of",true)
    else
      @encounter = Encounter.new("Empty encounter")
    end

    potion_type = ["heal","str","dex","con","int"]
    rand(1..3).times do
      @loot << Item.new("item",potion_type.sample,1,true)
    end
  end

  def about
    "#{@name}\n#{@description}\n\n"
  end

  def encounterComplete
    if @encounter.howMany > 0
      false
    else
      true
    end
  end

  def addConnection(connect_to)
     @connections << connect_to
  end

  def addChoices(choice)
    @choices << choice.to_s
  end

  def showChoices
    @choices.each_with_index do |i, c|
      puts "#{c}.#{i}"
    end
    puts "99.Exit game"
  end

end


#locations
ig_swamp = Location.new("Iguani Swamp")
ig_cave = Location.new("Iguani Cave")

#Put rooms in location
ig_swamp.addRoom(5)

def abilityCheck(ability,difficulty_class)
  @ability = ability
  @diff_class = difficulty_class
  if ability + rand(2..11) >= difficulty_class
    true
  else
    false
  end
end

if File.empty?("proj4_save.txt") == true
  ###
  player = Character.new("Mage","Human")
  player.writeSave
  else
  player = Character.new("Mage","Human")
end

def game(user)
  puts "Welcome to the cave, how deep can you dive? How long can you survive?!"
  # sleep(2.7)
  puts "You awaken in a strange dungeon, let's venture on and see what mysteries lie in store!"
  # sleep(3.3)
  loop do
    if user.info[:room].encounterComplete == true
    user.info[:room].about
    user.info[:room].showChoices
    print "What do you do: "
    choice = Integer(gets) rescue nil
      if choice.nil? == true
        clear
      #Change location
      elsif choice == 0
        mover(user)
      #Search room
      elsif choice == 1
        clear
        if user.info[:room].searched == false
          if abilityCheck(user.int,15) == false
            puts "Could'nt find anything of value."
            user.info[:room].searched = true
          else
            loop do
              clear
              puts "This is what you found, take ONE."
              user.info[:room].loot.each_with_index do |i, c|
                  puts "#{c}. #{i.name}"
              end
              selection = Integer(gets) rescue nil
              if selection.nil? == true
                clear
              else
                user.info[:inventory] << user.info[:room].loot[selection]
                user.info[:room].searched = true
                clear
                break
              end
            end
          end
        elsif  user.info[:room].searched == true
          puts "You have already searched this area"
        end
        elsif choice == 2
          clear
          user.useItem
        elsif choice == 3
          clear
          user.writeSave
          user.about
          puts
        elsif choice == 99
          clear
          user.writeSave
          user.about
          puts "Goodbye adventurer"
          break
        else
          clear
        end
      else
        if user.health > 0
          combat(user,user.info[:room].encounter)
      else
        puts "Game over"
        break
      end
    end
  end
end

def mover(user)
  clear
  connector = user.info[:loc].rooms[0]
  puts connector.about
  user.info[:room] = connector
  user.info[:loc].rooms.delete_at(0)
end

player.info[:loc] = ig_swamp
player.info[:room] = ig_swamp.rooms[0]
game(player)
