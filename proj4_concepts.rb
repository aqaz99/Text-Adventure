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
    @skill_points = 0
    @dead = false
    @inventory = Array.new
    @loot = Array.new
    @armor = {head: [],ring: [],chest: [],hands: [], legs: [],feet: []}
  end

  def statSet
    @maxHealth = @con * 10
    @curHealth = @maxHealth
  end

  def about
    puts "Name: #{@name}"
    puts "Race: #{@race}"
    puts "Health: #{@curHealth}/#{@maxHealth}"
    puts "Strength: #{@str}"
    puts "Constitution: #{@con}"
    puts "Dexterity: #{@dex}"
    puts "Intelligence: #{@int}"
  end

  def strengthAttack(target)
    #crit is the person attacking's dex mod
    crit = instance_variable_get(:@dex)
    #dodge is the receiving target's dex mod being subtracted from the hit chance
    dodge = target.instance_variable_get(:@dex)
    chance = rand(1..100)
    # puts "enemy crit:#{crit}"
    # puts "your dodge:#{dodge}"
    # puts "#{chance} - #{dodge} = #{chance-dodge}"
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
    # puts "#{chance} - #{dodge} = #{chance-dodge}"
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

  def buffStat(stat,magnitude,output = true)
    # clear
    if stat == "str"
      @str += magnitude
      if output
        puts "Strength increased by #{magnitude}, it is now #{@str}"
      end
    elsif stat == "con"
      @curHealth += (magnitude * 3)
      @maxHealth += (magnitude * 3)
      if output
        puts "Constitution increased by #{magnitude * 3}, max health is now #{@maxHealth}"
      end
    elsif stat == "dex"
      @dex += magnitude
      if output
        puts "Dexterity increased by #{magnitude}, it is now #{@dex}"
      end
    elsif stat == "int"
      @int += magnitude
      if output
        puts "Intelligence increased by #{magnitude}, it is now #{@int}"
      end
    else
      puts "Stat error"
    end
  end

  def applyBuffs (output = true)
    if @armor[:head].length > 0
      buffStat(@armor[:head][0].typeCheck,@armor[:head][0].instance_variable_get(:@lvl), output)
    end
    if @armor[:ring].length > 0
      buffStat(@armor[:ring][0].typeCheck,@armor[:ring][0].instance_variable_get(:@lvl), output)
    end
    if @armor[:chest].length > 0
      buffStat(@armor[:chest][0].typeCheck,@armor[:chest][0].instance_variable_get(:@lvl), output)
    end
    if @armor[:hands].length > 0
      buffStat(@armor[:hands][0].typeCheck,@armor[:hands][0].instance_variable_get(:@lvl), output)
    end
    if @armor[:legs].length > 0
      buffStat(@armor[:legs][0].typeCheck,@armor[:legs][0].instance_variable_get(:@lvl), output)
    end
    if @armor[:feet].length > 0
      buffStat(@armor[:feet][0].typeCheck,@armor[:feet][0].instance_variable_get(:@lvl), output)
    end
  end

  def increaseStat(stat,amount)
    #This method is for increasing the baseline of the players stats, not for armor or potions
    if stat == "str"
      @player_stats[:str] += amount
      resetStats
      puts "Strength increased by #{amount}, it is now #{@str}"
    elsif stat == "con"
      @player_stats[:con] += amount
      resetStats
      puts "Constitution increased by #{amount}, it is now #{@con}"
    elsif stat == "dex"
      @player_stats[:dex] += amount
      resetStats
      puts "Dexterity increased by #{amount}, it is now #{@dex}"
    elsif stat == "int"
      @player_stats[:int] += amount
      resetStats
      puts "Intelligence increased by #{amount}, it is now #{@int}"
    else
      puts "Stat error"
    end
  end

  def resetStats
    @str = @player_stats[:str]
    @con = @player_stats[:con]
    @dex = @player_stats[:dex]
    @int = @player_stats[:int]
    applyBuffs(false)
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
  #1
  def castSpell(targets)
    clear
    #2
    if targets.allDead == false
      #3
      loop do
        puts "Who do you want to cast a spell at?"
        list = targets.listEnemies()
        #Only takes integer inputs
        target = Integer(gets) rescue nil
        #4
        if (target.is_a? Integer) == true
          #5
          if list[target].nil? == true
            clear
            puts "Try again"
          else
            #6
            if list[target].health > 0
              clear
              magicAttack(list[target])
              break
            else
              #If your list within the encounter has zero health then it dies
              #The encounter class has removeEnemy method and targets is the encounter
              targets.removeEnemy(list[target])
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
      @inventory << Item.new("item",type,mag)
    end
  end

  def generateLoot(quant,type)
    potion_type = ["heal","str","dex","con","int"]
    slot_select = ["head","ring","chest","hands","legs","feet"]

    if type == "potion"
      quant.times do
        @loot << Item.new("item",potion_type.sample,1)
      end
    elsif type == "armor"
      quant.times do
        @loot << Equipment.new(slot_select.sample,"equipment",1)
      end
    else
      puts "Some error"
    end
  end

  def takeLoot
    loop do
      listLoot
      breakLoop = false
      choice = Integer(gets) rescue nil
      if (choice.is_a? Integer) == true
        #5
        if @loot[choice].nil? == true
          clear
          puts "Try again"
        elsif @loot[choice].name.downcase.include? "potion"
          clear
          @inventory << @loot[choice]
          puts "Added #{@loot[choice].name} to inventory"
          break
        else
          #check equipment
          clear
          loop do
          if @loot[choice].name.downcase.include? "helm"
            if @armor[:head].length == 0
              puts "#{@name} equipped #{@loot[choice].name}"
              @armor[:head].clear
              @armor[:head] << @loot[choice]
              breakLoop = true
              break
            elsif @armor[:head].length >= 0
              if switchEquipment(@armor[:head][0],@loot[choice]) == true
                @armor[:head].clear
                @armor[:head] << @loot[choice]
                puts "#{@name} equipped #{@loot[choice].name}"
                breakLoop = true
                break
              else
                puts "Item not equipped"
                break
              end
            end
          elsif @loot[choice].name.downcase.include? "ring"
            if @armor[:ring].length == 0
              puts "#{@name} equipped #{@loot[choice].name}"
              @armor[:ring].clear
              @armor[:ring] << @loot[choice]
              breakLoop = true
              break
            elsif @armor[:ring].length >= 0
              if switchEquipment(@armor[:ring][0],@loot[choice]) == true
                @armor[:ring].clear
                @armor[:ring] << @loot[choice]
                puts "#{@name} equipped #{@loot[choice].name}"
                breakLoop = true
                break
              else
                puts "Item not equipped"
                break
              end
            end
          elsif @loot[choice].name.downcase.include? "cuirass"
          if @armor[:chest].length == 0
            puts "#{@name} equipped #{@loot[choice].name}"
            @armor[:chest].clear
            @armor[:chest] << @loot[choice]
            breakLoop = true
            break
          elsif @armor[:chest].length >= 0
            if switchEquipment(@armor[:chest][0],@loot[choice]) == true
              @armor[:chest].clear
              @armor[:chest] << @loot[choice]
              puts "#{@name} equipped #{@loot[choice].name}"
              breakLoop = true
              break
            else
              puts "Item not equipped"
              break
            end
          end
          elsif @loot[choice].name.downcase.include? "gauntlets"
          if @armor[:hands].length == 0
            puts "#{@name} equipped #{@loot[choice].name}"
            @armor[:hands].clear
            @armor[:hands] << @loot[choice]
            breakLoop = true
            break
          elsif @armor[:hands].length >= 0
            if switchEquipment(@armor[:hands][0],armor) == true
              @armor[:hands].clear
              @armor[:hands] << @loot[choice]
              puts "#{@name} equipped #{@loot[choice].name}"
              breakLoop = true
              break
            else
              puts "Item not equipped"
              break
            end
          end
          elsif @loot[choice].name.downcase.include? "greaves"
          if @armor[:legs].length == 0
            puts "#{@name} equipped #{@loot[choice].name}"
            @armor[:legs] << @loot[choice]
            breakLoop = true
            break
          elsif @armor[:legs].length >= 0
            if switchEquipment(@armor[:legs][0],@loot[choice]) == true
              @armor[:legs].clear
              @armor[:legs] << @loot[choice]
              breakLoop = true
              break
              puts "#{@name} equipped #{@loot[choice].name}"
            else
              puts "Item not equipped"
              break
            end
          end
          elsif @loot[choice].name.downcase.include? "boots"
            if @armor[:feet].length == 0
              puts "#{@name} equipped #{@loot[choice].name}"
              @armor[:feet] << @loot[choice]
              breakLoop = true
              break
            elsif @armor[:feet].length >= 0
              if switchEquipment(@armor[:feet][0],@loot[choice]) == true
                @armor[:feet].clear
                @armor[:feet] << @loot[choice]
                puts "#{@name} equipped #{@loot[choice].name}"
                breakLoop = true
                break
              else
                puts "Item not equipped"
                break
              end
            end
          end
        end
      end
    end
    break if breakLoop
    end
    @loot.clear
  end

  def listLoot
    puts "Choose ONE item to loot, choose wisely"
    @loot.each_with_index do |i, c|
        puts "#{c}. #{i.name}"
    end
  end

  def equipArmor(armor)
    if armor.name.downcase.include? "helm"
      if @armor[:head].length == 0
        puts "#{@name} equipped #{armor.name}"
        @armor[:head].clear
        @armor[:head] << armor
      elsif @armor[:head].length >= 0
        if switchEquipment(@armor[:head][0],armor) == true
          @armor[:head].clear
          @armor[:head] << armor
          puts "#{@name} equipped #{armor.name}"
        else
          puts "Item not equipped"
        end
      end
    elsif armor.name.downcase.include? "ring"
      if @armor[:ring].length == 0
        puts "#{@name} equipped #{armor.name}"
        @armor[:ring].clear
        @armor[:ring] << armor
      elsif @armor[:ring].length >= 0
        if switchEquipment(@armor[:ring][0],armor) == true
          @armor[:ring].clear
          @armor[:ring] << armor
          puts "#{@name} equipped #{armor.name}"
        else
          puts "Item not equipped"
        end
      end
    elsif armor.name.downcase.include? "cuirass"
    if @armor[:chest].length == 0
      puts "#{@name} equipped #{armor.name}"
      @armor[:chest].clear
      @armor[:chest] << armor
    elsif @armor[:chest].length >= 0
      if switchEquipment(@armor[:chest][0],armor) == true
        @armor[:chest].clear
        @armor[:chest] << armor
        puts "#{@name} equipped #{armor.name}"
      else
        puts "Item not equipped"
      end
    end
    elsif armor.name.downcase.include? "gauntlets"
    if @armor[:hands].length == 0
      puts "#{@name} equipped #{armor.name}"
      @armor[:hands].clear
      @armor[:hands] << armor
    elsif @armor[:hands].length >= 0
      if switchEquipment(@armor[:hands][0],armor) == true
        @armor[:hands].clear
        @armor[:hands] << armor
        puts "#{@name} equipped #{armor.name}"
      else
        puts "Item not equipped"
      end
    end
    elsif armor.name.downcase.include? "greaves"
    if @armor[:legs].length == 0
      puts "#{@name} equipped #{armor.name}"
      @armor[:legs] << armor
    elsif @armor[:legs].length >= 0
      if switchEquipment(@armor[:legs][0],armor) == true
        @armor[:legs].clear
        @armor[:legs] << armor
        puts "#{@name} equipped #{armor.name}"
      else
        puts "Item not equipped"
      end
    end
    elsif armor.name.downcase.include? "boots"
      if @armor[:feet].length == 0
        puts "#{@name} equipped #{armor.name}"
        @armor[:feet] << armor
      elsif @armor[:feet].length >= 0
        if switchEquipment(@armor[:feet][0],armor) == true
          @armor[:feet].clear
          @armor[:feet] << armor
          puts "#{@name} equipped #{armor.name}"
        else
          puts "Item not equipped"
        end
      end
    end
  end

  def switchEquipment(current,new1)
    loop do
      puts "You have the #{current.name}, equip #{new1.name} instead?"
      puts "1.Yes 2.No"
      choice = gets.chomp.to_i
      if choice == 1
        #Return exits function
        #breaks only exit loops
        return true
      elsif choice == 2
        return false
      else
        clear
        puts "Try again"
      end
    end
  end

  def removeItem(item)
    @inventory.slice!(@inventory.index(item))
  end

  def itemEffect(item)
    clear
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
      @inventory.each_with_index do |i, c|
        puts "#{c}. #{i.name}"
      end
      choice = Integer(gets) rescue nil
      #3
      if (choice.is_a? Integer) == true
        #4
        if @inventory[choice].nil? == true
          clear
          puts "Try again"
        else
          itemEffect(@inventory[choice])
          removeItem(@inventory[choice])
          break
        end#4
      end#3
    end#2
  end#1

  def giveExp(amount)
    $experience += amount
  end

  def levelUp
    if $experience  >= (@level * 100)
      @level += ($experience / 100)
      @skill_points += ($experience / 100)
      $experience -= (@level * 100)
      puts "Level up! You are now level #{@level}"

      until @skill_points == 0
        choice = 0
        clear
        resetStats
        puts "You have #{@skill_points} skill points, what skill do you want to upgrade?"
        puts "1.Strength:#{@str}  2.Constitution:#{@con}  3.Dexterity:#{@dex}  4.Intelligence:#{@int}"
        choice = Integer(gets) rescue nil

        if (choice.is_a? Integer) == true
          if choice == 1
            clear
            increaseStat("str",1)
            @skill_points -= 1
          elsif choice == 2
            clear
            increaseStat("con",1)
            @skill_points -= 1
          elsif choice == 3
            clear
            increaseStat("dex",1)
            @skill_points -= 1
          elsif choice == 4
            clear
            increaseStat("int",1)
            @skill_points -= 1
          else
            puts "Try again"
          end
        end
      end
    end
  end

  def noItems
    if @inventory.empty? == true
      true
    else
      false
    end
  end
end
class Encounter
  attr_reader :name
  attr_accessor :variable

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

  def howMany
    @enemies.length
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

    randomRoller = rand(1..100)
    if randomRoller <= 70
      magnitude = 1
    elsif randomRoller >= 71 && randomRoller < 92
      magnitude = 2
    else
      magnitude = 3
    end

    @name = name
    @type = type
    @magnitude = magnitude.to_i

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
class Equipment
  attr_reader :name
  attr_accessor :variable

  def initialize(name,type,lvl)
    randomRoller = rand(1..100)
    if randomRoller <= 50
      powerLvl = 1
    elsif randomRoller >= 51 && randomRoller < 75
      powerLvl = 2
    elsif randomRoller >= 75 && randomRoller < 85
      powerLvl = 4
    elsif randomRoller >= 85 && randomRoller < 92
      powerLvl = 6
    elsif randomRoller >= 92 && randomRoller < 97
      powerLvl = 8
    elsif randomRoller >= 97
      powerLvl = 10
    end
    enchantment = ["of Strength","of Dexterity","of Constitution","of Intelligence"]

    @name = name
    @type = type
    @lvl = powerLvl

    if name == "head"
      mod = enchantment.sample
      @lvl = powerLvl.to_i
      @name = "Helm " + mod + " " + powerLvl.to_s

      if mod.include? "Strength"
        @type = "str"
        elsif mod.include? "Dexterity"
        @type = "dex"
        elsif mod.include? "Constitution"
        @type = "con"
        elsif mod.include? "Intelligence"
        @type = "int"
      end

    elsif name == "ring"
      mod = enchantment.sample
      @lvl = powerLvl
      @name = "Ring " + mod + " " + powerLvl.to_s

      if mod.include? "Strength"
        @type = "str"
        elsif mod.include? "Dexterity"
        @type = "dex"
        elsif mod.include? "Constitution"
        @type = "con"
        elsif mod.include? "Intelligence"
        @type = "int"
      end

    elsif name == "chest"
      mod = enchantment.sample
      @lvl = powerLvl
      @name = "Cuirass " + mod + " " + powerLvl.to_s

      if mod.include? "Strength"
        @type = "str"
        elsif mod.include? "Dexterity"
        @type = "dex"
        elsif mod.include? "Constitution"
        @type = "con"
        elsif mod.include? "Intelligence"
        @type = "int"
      end

    elsif name == "hands"
      mod = enchantment.sample
      @lvl = powerLvl
      @name = "Gauntlets " + mod + " " + powerLvl.to_s

      if mod.include? "Strength"
        @type = "str"
        elsif mod.include? "Dexterity"
          @type = "dex"
        elsif mod.include? "Constitution"
          @type = "con"
        elsif mod.include? "Intelligence"
        @type = "int"
      end

    elsif name == "legs"
      mod = enchantment.sample
      @lvl = powerLvl
      @name = "Greaves " + mod + " " + powerLvl.to_s

      if mod.include? "Strength"
        @type = "str"
        elsif mod.include? "Dexterity"
        @type = "dex"
        elsif mod.include? "Constitution"
        @type = "con"
        elsif mod.include? "Intelligence"
        @type = "int"
      end

    elsif name == "feet"
      mod = enchantment.sample
      @lvl = powerLvl
      @name = "Boots " + mod + " " + powerLvl.to_s

      if mod.include? "Strength"
        @type = "str"
        elsif mod.include? "Dexterity"
        @type = "dex"
        elsif mod.include? "Constitution"
        @type = "con"
        elsif mod.include? "Intelligence"
        @type = "int"
      end
    end
  end

  def typeCheck
    @type
  end
end

#1
def combat(player,enemies)
  player.generateLoot(enemies.howMany,"potion")
  player.generateLoot(enemies.howMany,"armor")
  player.resetStats
  puts "You are fighting #{enemies.name}"
  player_turn = true
  #2
  loop do
    if enemies.allDead == true

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
        enemies.removeDead
        #Enemy turn
        puts
        if enemies.allDead == false
          puts "Enemy turn"
        else
          break
        end
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
  player.resetStats
  player.levelUp
  player.takeLoot
end #1

clear
mage = Character.new("Mage","Human")

enc1 = Encounter.new("Group of Iguani")
enc2 = Encounter.new("Group of Dwarves")
enc3 = Encounter.new("Group of asdsad")

#parameters are (amount,racename)
enc1.addEnemy(1,"Iguani")
# enc1.addEnemy(1,"Dwarf")
enc1.addEnemy(3,"Elf")
# enc1.addEnemy(1,"Human")

enc2.addEnemy(4,"Iguani")

enc3.addEnemy(3,"Iguani")

mage.addItem(1,"heal",1)
mage.addItem(1,"str",1)
mage.addItem(1,"con",1)
mage.addItem(1,"dex",1)
mage.addItem(4,"int",1)



mage.giveExp(300)
combat(mage,enc1)

mage.giveExp(600)
combat(mage,enc2)
combat(mage,enc2)
