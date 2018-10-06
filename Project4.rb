#+--------------------------+
#|\Project 4  ||project4.rb/|
#|            ||            |
#|           #++#           |
#+-    The Crimson King    -+
#|           #++#           |
#|            ||   James    |
#|/           ||Miners-Webb\|
#+--------------------------+


class Location
  attr_reader :name

  def initialize(name)
    @name = name
    @connections = Array.new
  end

  def addConnection(location)
    @connections << location
  end

  #@name references the object that enters the class so if you access this class with current_loc its "name" is going through as current_loc
  def showConnections
    puts  "#{@name} connects to:"
    @connections.each_with_index do |i, c|
      puts "#{c}.#{i.name}"
    end
    puts "Where do you want to move go?"
    choice = gets.chomp.to_i
    getConnection(choice)
  end

  def getConnection(loc_number)
    @connections[loc_number]
  end
end


def clear
  print "\e[H\e[2J"
end
#locations
ig_swamp = Location.new("Iguani Swamp")
ig_cave = Location.new("Iguani Cave")

#Connections
ig_swamp.addConnection(ig_cave)
ig_cave.addConnection(ig_swamp)

races = ["Human", "Elf", "Dwarf"]

human_stats = {str: 5,con: 5,dex: 5,int: 5}
elf_stats = {str: 3,con: 4,dex: 6,int: 7}
dwarf_stats = {str: 6,con: 7,dex: 3,int: 4}

#Need to set empty values initially before it checks files
char_name = ""
char_race = ""
char_class = "Mage"

#Charachter spells
char_spells = ["Fireball","Ice Lance","Lightning bolt"]

#Progress variables
char_level = 1
char_location = "Start"

#Branching path variables
branch1 = false
branch2 = false
branch3 = false

#Opens the save file and gets name/race/class if they exist
name_check = true
race_check = true
class_check = true
File.open("proj4_save.txt").each do |line|
  if name_check == false && race_check == false
    char_class = line.to_s.chomp
  elsif name_check == false
    char_race = line.to_s.chomp
    race_check = false
  elsif name_check == true
    char_name = line.to_s.chomp
    name_check = false
  end
end
#Character level and location check
lvl_check = true
File.open("proj4_progress.txt").each do |line|
  if lvl_check == true
    char_level = line.to_s
    lvl_check = false
  else
    char_location = line.to_s
  end
end

# puts
# print "#{char_name.chomp}, the #{char_race.chomp} #{char_class.chomp}"
# puts
# print "Level #{char_level}Location: #{char_location}"
# puts


#First run if file is empty
if File.empty?("proj4_progress.txt") == true
  puts "What is your name?"
  char_name = gets.chomp
  puts

  puts "What race are you, #{char_name}?"
  races.each_with_index { |val, idx| print "#{idx+1}. #{val} " }
  char_race = gets.chomp.to_i
  puts

  if char_race == 1
    char_race = "Human"
    elsif char_race == 2
      char_race = "Elf"
    elsif char_race == 3
      char_race = "Dwarf"
  end

  charachter = {name: char_name, race: char_race, class: char_class}

  #Writes the name/class/race to file
  File.open("proj4_save.txt","w") do |line|
   line.puts "#{char_name}"
   line.puts "#{char_race}"
   line.puts "#{char_class}"
  end

  #Print charachter
  puts "#{char_name}, the #{char_race} #{char_class}"
  puts

  #Writes level and location
  char_location = "Iguani Swamp"
  File.open("proj4_progress.txt","w") do |line|
    line.puts "#{char_level}"
    line.puts "#{char_location}"
  end
end

#Sets charachter stats equal to chosen race stats
if char_race == "Human"
    char_stats = human_stats
  elsif char_race == "Dwarf"
    char_stats = dwarf_stats
  elsif char_race == "Elf"
    char_stats = elf_stats
  end

def options(text)
  @text = text
  puts
  puts text
  print "What do you do: "
  gets.chomp.to_i
end
#Bool used if user fails abilit check
failed = false
def ability_check(ability,difficulty_class)
  @ability = ability
  @diff_class = difficulty_class
  ability + rand(difficulty_class)
end
# def combat(enemies,char_spells)
#   @enemies = enemies[]
#   @char_spells = char_spells[]
#   choice = 0
#   player_turn = true
#   puts "What do you do:"
#   puts char_spells.each_with_index
#   choice = gets.chomp.to_i
#   loop do
#     if choice == 1
#       break
#     elsif choice == 2
#       break
#     elsif choice ==3
#       break
#     else
#       puts "Pick a number between 1 and "
#     end
#   end
# end
#Location check after start, charachter wakes up in Iguani swamp
lvl_check = true
File.open("proj4_progress.txt").each do |line|
  if lvl_check == true
    char_level = line.to_s
    lvl_check = false
  else
    char_location = line.to_s.chomp
  end
end

if char_location == "Iguani Swamp"
  loop do
    puts "You shake your slumber off, trees passing you overhead. Something is dragging you through the mire."
    puts "You look up and see what appears to be an upright lizard-like...thing."
    puts "It appears to be dragging you down into the entrance of a cave."
    choice = options("1.Call our to the beast 2.Attempt to shake your leg free 3.Fight the beast")
      if choice == 1
        puts "You struggle to find your voice, your throat feels as though it has been ages since it spoke a word."
        puts "The beast whips its terrifying head back in shock at the strange noises coming from behind it."
        puts "It starts to yell indistinctly at you and reaches for the thorned club on its side."
        break
      elsif choice == 2
        puts "You wiggle your leg weakly in the beasts grasp, your strength has not returned to you."
        puts "The beast whips its terrifying head back in shock and begins to yell indistinctly at you. \nIt reaches for the thorned club on its side. "
        break
      elsif choice == 3
        puts "Yes! Fight! But how? You can't seem to remember in which ways you used to defend yourself."
        break
      end
  end
  loop do
    options("1.Search your body for weapons 2.Try and punch the lizard beast 3.Fireball!")
    if choice == 1
      puts "You quickly scour your body and find nothing but a book."
      puts "You hear a thunk and your vision goes black."
      break
    elsif choice == 2
      puts "You get to your feet and throw a punch towards the lizard."
      puts "The punch lands on the lizards chin but doesn't seem to have a lasting effect."
      puts "It brings its club around to your temple, your vision goes black."
      break
    elsif choice == 3
      puts "Time seems to slow as you focus your energy into your palm."
      puts "You feel your body warming as a small light begins to emanate from your hand."
      puts "The lizards club connects with your temple, your vision goes black. Maybe your a bit rusty."
      break
    end
  end
  #At end sets and saves new location
  char_location = "Iguani Cave"
  File.open("proj4_progress.txt","w") do |line|
    line.puts "#{char_level}"
    line.puts "#{char_location}"
  end
end

#Tutorial/railroading to start charachter off.
if char_location == "Iguani Cave"
  loop do
    puts "Once again, you awaken. This time in crude iron chains."
    puts "You sit bounded before a small fire within a cave. \nYou hear lizard voices eachoing off the cave walls, but cannot find the source."
    puts "Bones from varying species litter the ground around you."
    puts "The fire infront you dances infront of your eyes and you feel drawn to it."
    puts
    if failed == false
      choice = options("1.Pull at the chains and attempt to break free 2.Focus on fire and watch as it dances")
    else
      choice = options("2.Focus on fire and watch as it dances")
    end
    if choice == 1 && failed == false
      check = ability_check(char_stats[:str],10)
      if check >= 10
        puts "You summon what strength you can and pull up against the chains."
        puts "Your wrists break through as they fall to the ground with a loud clatter."
        puts
        puts "The noise seems to have alerted the others."
        puts "The shuffling of feet getting louder, as three similar looking lizard beast come into the cavern."
        puts
        branch1 = true
        break
      elsif check < 10
        puts "You summon what strength you can and pull up against the chains."
        puts "These chains seem to be stronger than they look."
        puts "You fail to break free."
        puts
        failed = true
      end
    elsif choice == 2
      puts "After staring into the fire, it seems to radiate its energy into you."
      puts "You feel warmer, stronger, able to break free from these flimsy chains."
      puts "The chains begin to melt off your wrists."
      puts "You are free."
      puts
      branch2 == true
      break
    else
      puts "Incorrect input"
      puts
    end
  end
  ##In the cave but out of the first loop
  if branch1 == true

  end

  if branch2 == true

  end
end
#
