#Proj4 concepts
def clear
  print "\e[H\e[2J"
end



class Npc
  attr_reader :name
  attr_accessor :variable

  def initialize(name,race)

    @player_stats = {str: 5,con: 50,dex: 5,int: 5}

    iguani_stats = {str: 3,con: 4,dex: 3,int: 2}
    human_stats = {str: 5,con: 5,dex: 5,int: 5}
    elf_stats = {str: 3,con: 4,dex: 6,int: 7}
    dwarf_stats = {str: 6,con: 7,dex: 3,int: 4}

    enemy_names = ["ba","da","ma","pa","ta","for","dor","mor","kor","vor","mek","dek","pek","gek","tek","tum","rum","pum","vum","xun"]
      dwarf_prefix = ["Iron","Steel","Bronze","Magma","Storm","Mountain","Stone","Obsidian","Grey","Strong","Fire","Elder"]
      dwarf_suffix = ["Hammer","Forge","Hearth","Mountain","Killer","Shield","Hand","Belly","Beard","Smasher","King","Axe"]
      elf_prefix = ["ael","aef","al","ari","bael","cal","cor","el","fera","gar","keth","kor","lam","lue","mai","rua","mara","se","sol",
      "tha","tho","vil"]
      elf_suffix = ["ae","ael","aer","al","el","avel","nis","nal","lon","lyn","or","reth","ran","deth","dre","dul","emar","fel","in",
      "im","kash","lian","yth","zair"]
      human_firstname = ["Adam","Bernarnd","Cornelius","Darius","Egon","Felix","Giddeon","Huri","Humberto","Ike","Jugan","Kyle","Thomas","William","Hugh"]
      human_lastname = ["Anderson","Smith","Johnson","Williams","Brown","Jones","Davis","Carpenter","Lee","Walker","Nelson","Adams","Turner","Phillips","Rogers","Cook","Mann"]

    @level = 1
    @race = race

    if race == "Iguani"
      @name = ((enemy_names.sample) + (enemy_names.sample)).capitalize
      @str = iguani_stats[:str]
      @con = iguani_stats[:con]
      @dex = iguani_stats[:dex]
      @int = iguani_stats[:int]
      elsif race == "Human"
      @name = ((human_firstname.sample) + " " + (human_lastname.sample))
      @str = human_stats[:str]
      @con = human_stats[:con]
      @dex = human_stats[:dex]
      @int = human_stats[:int]
      elsif race == "Elf"
      @name = ((elf_prefix.sample) + "'" + (elf_suffix.sample) + (elf_suffix.sample)).capitalize
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
    if name == "Mage"
      @name = name
      @str = @player_stats[:str]
      @con = @player_stats[:con]
      @dex = @player_stats[:dex]
      @int = @player_stats[:int]
    end

    statSet
    $experience = 0
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

  def strengthAttack(target)
    #crit is the person attacking's dex mod
    crit = instance_variable_get(:@dex)
    #dodge is the receiving target's dex mod being subtracted from the hit chance
    dodge = target.instance_variable_get(:@dex)
    chance = rand(1..100)
    puts "enemy crit:#{crit}"
    puts "your dodge:#{dodge}"
    puts "#{chance} - #{dodge} = #{chance-dodge}"
    if chance < (10 + dodge)
      puts "#{@name} missed"
    elsif chance > (10 + dodge) && chance < (90 - crit)
      dmgFloor = ((@str) /2).floor
      dmgCeil = (@str) *2
      target.takeDamage(rand(dmgFloor..dmgCeil))
    elsif chance >= (90 - crit)
      puts "Crit!"
      crit = (@str) * 3
      target.takeDamage(crit)
    end
  end

  def magicAttack(target)
    dodge = target.instance_variable_get(:@dex)
    chance = rand(1..100)
    puts "#{chance} - #{dodge} = #{chance-dodge}"
    if chance < (10 + dodge)
      puts "#{@name} missed"
    elsif chance > (10 + dodge) && chance < 90
      dmgFloor = ((@int) /2).floor
      dmgCeil = (@int) *2
      target.takeDamage(rand(dmgFloor..dmgCeil))
    elsif chance >= 90
      puts "Crit!"
      crit = (@int) * 3
      target.takeDamage(crit)
    end
  end

  def takeDamage(dmg)
    if @curHealth - dmg <= 0
      puts "#{@name} took #{dmg} damage and died"
      @curHealth = 0
    else
      @curHealth -= dmg
      puts "#{@name} took #{dmg} damage. HP:#{@curHealth}/#{@maxHealth}"
    end
  end

  def healDamage(heal)
    if (@curHealth + heal.to_i) >= @maxHealth
      clear
      @curHealth = @maxHealth
      puts "#{@name} healed #{heal}. HP:#{@curHealth}/#{@maxHealth}"
    else
      clear
      @curHealth += heal.to_i
      puts "#{@name} healed #{heal}. HP:#{@curHealth}/#{@maxHealth}"
    end
  end

  def health
    @curHealth
  end

  def buffStat(stat,magnitude)
    clear
    if stat == "str"
      @str += magnitude
      puts "Strength increased by #{magnitude}"
    elsif stat == "con"
      @curHealth += magnitude
      @maxHealth += magnitude
      puts "Constitution increased by #{magnitude}"
    elsif stat == "dex"
      @dex += magnitude
      puts "Dexterity increased by #{magnitude}"
    elsif stat == "int"
      @int += magnitude
      puts "intelligence increased by #{magnitude}"
    else
      puts "Stat error"
    end
  end

  def increaseStat(stat,amount)
    if stat == "str"
      @player_stats[:str] += amount
      puts "Strength increased by #{amount}"
    elsif stat == "con"
      @player_stats[:con] += amount
      puts "Constitution increased by #{amount}"
    elsif stat == "dex"
      @player_stats[:dex] += amount
      puts "Dexterity increased by #{amount}"
    elsif stat == "int"
      @player_stats[:int] += amount
      puts "intelligence increased by #{amount}"
    else
      puts "Stat error"
    end
  end

  def resetStats
    @str = @player_stats[:str]
    @con = @player_stats[:con]
    @dex = @player_stats[:dex]
    @int = @player_stats[:int]
    # puts "#{@str}"
    # puts "#{@dex}"
    # puts "#{@con}"
    # puts "#{@int}"
    # puts "#{$experience} exp"
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
    if targets.allDead == false
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
              clear
              magicAttack(selection[target])
              break
            else
              #If your selection within the encounter has zero health then it dies
              #The encounter class has removeEnemy method and targets is the encounter
              targets.removeEnemy(selection[target])
              giveExp(10)
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

  def addItem(amount,type,mag)
    amount.times do
      @items << Item.new("item",type,mag)
    end
  end
  def removeItem(item)
    @items.slice!(@items.index(item))
  end

  def itemEffect(item)
    if item.typeCheck == "heal"
      healDamage(item.magSet)
    else
      buffStat(item.typeCheck,item.magSet)
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

  def levelUp
    if $experience  >= (@level * 100)
      @level += 1
      $experience = 0
      puts "Level up! You are now level #{@level}"
    end
  end

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
        $experience += 25
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

  def allDead
    if @enemies.empty? == true
      true
    else
      false
    end
  end

  def enemyAttack(target)
    removeDead
    @enemies.each_with_index do |i, c|
      dmgFloor = ((i.instance_variable_get(:@str)) /2).floor
      dmgCeil = (i.instance_variable_get(:@str)) *2
      puts "#{i.name} attacks!"
      i.strengthAttack(target)
      puts
    end
  end

end
class Item
  attr_reader :name
  attr_accessor :variable

  def initialize(name,type,magnitude)
    @name = name
    @type = type
    @magnitude = magnitude

    if type == "heal" && magnitude == 1
      @name = "Lesser health potion"
      elsif type == "heal" && magnitude == 2
      @name = "Health potion"
      elsif type == "heal" && magnitude == 3
      @name = "Greater health potion"
    end

    if type == "str" && magnitude == 1
      @name = "Lesser potion of strength"
    elsif type == "str" && magnitude == 2
      @name = "Potion of strength"
    elsif type == "str" && magnitude == 3
      @name = "Greater potion of strength"
    end

    if type == "con" && magnitude == 1
      @name = "Lesser potion of constitution"
    elsif type == "con" && magnitude == 2
      @name = "Potion of constitution"
    elsif type == "con" && magnitude == 3
      @name = "Greater potion of constitution"
    end

    if type == "dex" && magnitude == 1
      @name = "Lesser potion of dexterity"
    elsif type == "dex" && magnitude == 2
      @name = "Potion of dexterity"
    elsif type == "dex" && magnitude == 3
      @name = "Greater potion of dexterity"
    end

    if type == "int" && magnitude == 1
      @name = "Lesser potion of intelligence"
    elsif type == "int" && magnitude == 2
      @name = "Potion of intelligence"
    elsif type == "int" && magnitude == 3
      @name = "Greater potion of intelligence"
    end
  end

  def typeCheck
    @type = @type
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
    if enemies.allDead == true
      puts "You win"
      break
    else
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
      elsif player_turn == false
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
    end
    end #3
  end #2
  player.levelUp
  player.resetStats
end #1

clear
mage = Character.new("Mage","Human")

enc1 = Encounter.new("Group of Iguani")
enc2 = Encounter.new("Group of Dwarves")

#parameters are (amount,racename)
enc1.addEnemy(1,"Iguani")
enc1.addEnemy(1,"Dwarf")
enc1.addEnemy(1,"Elf")
# enc1.addEnemy(1,"Human")

enc2.addEnemy(2,"Dwarf")

mage.addItem(6,"heal",3)
mage.addItem(2,"str",3)
mage.addItem(2,"con",3)
mage.addItem(2,"dex",3)
mage.addItem(2,"int",3)


# mage.addItem(int_pot1)
# mage.addItem(int_pot1)
# mage.addItem(dex_pot1)
# mage.addItem(con_pot1)
# mage.addItem(str_pot1)
# mage.addItem(health_pot2)
# mage.addItem(health_pot3)



combat(mage,enc1)
combat(mage,enc2)

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
