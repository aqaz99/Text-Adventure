#Proj4 concepts
def clear
  print "\e[H\e[2J"
end



class Npc
  attr_reader :name
  attr_accessor :variable

  def initialize(name,race)
    iguani_stats = {str: 3,con: 4,dex: 3,int: 2}
    human_stats = {str: 5,con: 5,dex: 5,int: 5}
    elf_stats = {str: 3,con: 4,dex: 6,int: 7}
    dwarf_stats = {str: 6,con: 7,dex: 3,int: 4}

    enemy_names = ["ba","da","ma","pa","ta","for","dor","mor","kor","vor","mek","dek","pek","gek","tek","tum","rum","pum","vum","xun"]
    dwarf_prefix = ["Iron","Steel","Bronze","Magma","Storm","Mountain","Stone","Obsidian","Grey","Strong","Fire","Elder"]
    dwarf_suffix = ["Hammer","Forge","Hearth","Mountain","Killer","Shield","Hand","Belly","Smasher","King","Axe"]
    if name != "Mage"
      @name = ((enemy_names.sample) + (enemy_names.sample)).capitalize
      else
      @name = name
    end
    @race = race
    if race == "Iguani"
      @name = ((enemy_names.sample) + (enemy_names.sample)).capitalize
      @str = iguani_stats[:str]
      @con = iguani_stats[:con]
      @dex = iguani_stats[:dex]
      @int = iguani_stats[:int]
      elsif race == "Human"
      @str = human_stats[:str]
      @con = human_stats[:con]
      @dex = human_stats[:dex]
      @int = human_stats[:int]
      elsif race == "Elf"
      @str = elf_stats[:str]
      @con = elf_stats[:con]
      @dex = elf_stats[:dex]
      @int = elf_stats[:int]
      elsif race == "Dwarf"
      @name = ((dwarf_prefix.sample) + " " + (dwarf_suffix.sample))
      @str = dwarf_stats[:str]
      @con = dwarf_stats[:con]
      @dex = dwarf_stats[:dex]
      @int = dwarf_stats[:int]
    end
    statSet

    @dead = false
    @items = Array.new
  end

  def statSet
    @maxHealth = @con * 10
    @curHealth = @maxHealth

  end



  def about
    puts "Name: #{@name}"
    puts "Race: #{@race}"
    puts "Health: #{@curHealth}/#{@maxHealth}"
  end

  def dealDamage
    @str
  end

  def takeDamage(dmg)
    if @curHealth - dmg <= 0
      puts "#{@name} took #{dmg} damage and died"
      @curHealth = 0
    else
      @curHealth -= dmg
      puts "#{@name} took #{dmg} damage. #{@curHealth}HP left"
    end
  end

  def healDamage(heal)
    if (@curHealth + heal.to_i) >= @maxHealth
      @curHealth = @maxHealth
      puts "#{@name} healed #{heal} health"
    else
      @curHealth += heal.to_i
      puts "#{@name} healed #{heal} health"
    end
  end

  def health
    @curHealth
  end

  def isDead
    if @curHealth <= 0
      true
    else
      false
    end
  end
end
class Character < Npc
  attr_reader :name

  #1
  def castSpell(targets)
    clear
    #2
    if targets.encArray.empty? == false
      #3
      loop do
        puts "Who do you want to cast a spell at?"
        selection = targets.listEnemies()
        #Only takes integer inputs
        target = Integer(gets) rescue nil
        #4
        if (target.is_a? Integer) == true
          #5
          if selection[target].nil? == true
            clear
            puts "Try again"
          else
            #6
            if selection[target].health > 0
              selection[target].takeDamage(rand(5..10))
              break
            else
              #If your selection within the encounter has zero health then it dies
              #The encounter class has removeEnemy method and targets is the encounter
              targets.removeEnemy(selection[target])
              break
              end#6
            end#5
          else
            clear
            puts "Try again"
          end#4
        end#3
      end#2
  end#1

  def addItem(item)
    @items << item
  end

  def removeItem(item)
    clear
    puts "#{item.name} used"
    @items.slice!(@items.index(item))
  end

  def itemEffect(item)
    if item.isHeal == true
      healDamage(item.magSet)
    end
  end

  #1
  def useItem
    #2
    loop do
      clear
      puts "What item do you want to use?"
      @items.each_with_index do |i, c|
        puts "#{c}. #{i.name}"
      end
      choice = Integer(gets) rescue nil
      #3
      if (choice.is_a? Integer) == true
        #4
        if @items[choice].nil? == true
          clear
          puts "Try again"
        else
          itemEffect(@items[choice])
          removeItem(@items[choice])
          break
        end#4
      end#3
    end#2
  end#1

  def noItems
    if @items.empty? == true
      true
    else
      false
    end
  end
end
class Encounter
  attr_reader :name

  def initialize(name)
    @name = name
    @enemies = Array.new
  end

  def addEnemy(amount,race)
    amount.times do
      @enemies << Npc.new("warrior1",race)
    end
  end

  def removeEnemy(enemy)
    @enemies.each do |i|
      if enemy.isDead == true
        @enemies.delete(enemy)
      end
    end
  end

  def removeDead
    @enemies.each do |i|
      removeEnemy(i)
    end
  end

  def listEnemies
    removeDead
    @enemies.each_with_index do |i, c|
        puts "#{c}. #{i.name}"
    end
  end

  def enemyAttack(target)

    removeDead
    @enemies.each_with_index do |i, c|
      dmgFloor = ((i.dealDamage) /2).floor
      dmgCeil = (i.dealDamage) *2
      puts "#{i.name} attacks!"
      target.takeDamage(rand(dmgFloor..dmgCeil))
      puts
    end
  end

  def encArray
    #This method is used within charachter to check if it is empty
    @enemies
  end
end
class Item
  attr_reader :name

  def initialize(name,heal,buff,magnitude)
    @name = name
    @heal = heal
    @buff = buff
    @magnitude = magnitude
  end

  def isHeal
    if @heal == true
      true
    else
      false
    end
  end
  def isBuff
    if @buff == true
      true
    else
      false
    end
  end
  def magSet
    if @magnitude == 1
      @magnitude = 5
    elsif @magnitude == 2
      @magnitude = 15
    elsif @magnitude == 3
      @magnitude = 25
    end
  end
end
#1
def combat(player,enemies)
  puts "You are fighting #{enemies.name}"
  player_turn = true
  #2
  loop do
    #3
    if player.health > 0
      #4
      if player_turn == true
        #Player turn
        puts "1.Cast spell 2.Use item"
        print "What do you do: "
        choice = gets.chomp.to_i
        #5
        if choice == 1
          player.castSpell(enemies)
          player_turn = false
        elsif choice == 2
          if player.noItems == false
            player.useItem
            player_turn = false
            else
            clear
            puts "You are out of items"
          end
        else
          clear
          puts "Choose a valid option"
        end #5
      else
        #Enemy turn
        puts
        puts "Enemy turn"
        puts
        enemies.enemyAttack(player)
        player_turn = true
      end #4
    else
      puts "You are dead"
      break
    end #3
  end #2
end #1

clear
mage = Character.new("Mage","Human")

health_pot1 = Item.new("Lesser health potion",true,false,1)
health_pot2 = Item.new("Health potion",true,false,2)
health_pot3 = Item.new("Greater health potion",true,false,3)


enc1 = Encounter.new("Group of Iguani")

#parameters are (amount,racename)
enc1.addEnemy(2,"Iguani")
enc1.addEnemy(2,"Dwarf")

# enc1.addEnemy(warrior2)
# enc1.addEnemy(warrior3)
# enc1.addEnemy(warrior4)


mage.addItem(health_pot1)
mage.addItem(health_pot1)
mage.addItem(health_pot2)
mage.addItem(health_pot3)

combat(mage,enc1)


# warrior1 = Character.new("warrior1","Dwarf",50,45)
# warrior1.about
# warrior1.healDamage(3)
# warrior1.about
# warrior1.healDamage(7)
# warrior1.about
# james = Npc.new("James","Orc",50,50)
# drew = Npc.new("Drew","Human",40,40)
#
# james.about
# drew.about
#
# james.takeDamage(10)
# james.about
# james.takeDamage(30)
# james.about
# james.takeDamage(30)
