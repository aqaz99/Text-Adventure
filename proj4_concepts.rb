#Proj4 concepts
def clear
  print "\e[H\e[2J"
end


class Entity
  attr_reader :name
  attr_accessor :info, :name, :race, :str, :int, :dex, :con

  def initialize(name,race)
                    #Str,Con,Dex,Int
    @info = {stats: [5,6,5,5],exp: 0,skpts: 0,level: 1,loc: "Start",room: "Start",inventory: []}

    iguani_stats = {str: 3,con: 1,dex: 3,int: 2}
    human_stats = {str: 5,con: 1,dex: 5,int: 5}
    elf_stats = {str: 3,con: 1,dex: 6,int: 7}
    dwarf_stats = {str: 6,con: 1,dex: 3,int: 4}

    enemy_names = ["gra","sla","fra","ba","da","ma","pa","ta","qa","for","dor","xor","mor","por","kor","vor","mek","dek","pek","gek","tek","yun","vun","lun","dum","tum","rum","pum","vum","xun"]
      dwarf_prefix = ["The Great","Iron","Steel","Bronze","Magma","Storm","Mountain","Stone","Obsidian","Grey","Strong","Fire","Elder","Twilight","Dragon","Old","Young","War","Thunder","Silver","Golden"]
      dwarf_suffix = ["Hammer","Forge","Hearth","Mountain","Killer","Prince","Shield","Hand","Belly","Beard","Smasher","King","Axe","Gaurd","Brew","Fury","Ward"]
      elf_prefix = ["ael","aef","al","ari","bael","cal","cor","el","fera","gar","keth","kor","lam","lue","mai","rua","mara","se","sol",
      "tha","tho","vil"]
      elf_suffix = ["ae","ael","aer","al","el","avel","nis","nal","lon","lyn","or","reth","ran","deth","dre","dul","emar","fel","in",
      "im","kash","lian","yth","zair"]
      human_firstname = ["Adam","Alexander","Bartholomew","Carter","Eric","Bret","Bernarnd","Winston","Chris","Hudson","Cornelius","Darius","Egon","Ferdinand","Felix","Greg","Giddeon","Huri","Humberto","Ike","Jack","Jugan","Kyle","Thomas","William","Hugh","Vladimir"]
      human_lastname = ["Anderson","Smith","Churchill","Goodwin","Johnson","Ligand","Williams","Cromwell","Pavlov","Brown","Grey","Jones","Spalding","Davis","Carpenter","Lee","Walker","Nelson","Adams","Turner","Phillips","Rogers","Cook","Mann"]


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
      @armor = {head: "",ring: "",chest: "",hands: "", legs: "",feet: ""}
      @name = name
      @armor[:head] = Equipment.new("head","str",0,false)
      @armor[:ring] = Equipment.new("ring","str",0,false)
      @armor[:chest] = Equipment.new("chest","str",0,false)
      @armor[:hands] = Equipment.new("hands","str",0,false)
      @armor[:legs] = Equipment.new("legs","str",0,false)
      @armor[:feet] = Equipment.new("feet","str",0,false)
      readSave
      #str
      @str = @info[:stats][0]
      #con
      @con = @info[:stats][1]
      #dex
      @dex = @info[:stats][2]
      #int
      @int = @info[:stats][3]
    end
    statSet
    @dead = false
    @loot = Array.new
  end

  def statSet
    @maxHealth = @con * 10
    @curHealth = @maxHealth
  end

  def about
    info = ["Name: #{@name}","Race: #{@race}","Location: #{@info[:loc].name}","Room: #{@info[:room].name}",
    "Health: #{@curHealth}/#{@maxHealth}","Strength: #{@str}","Constitution: #{@con}",
    "Dexterity: #{@dex}","Intelligence: #{@int}"]

    info.each do |i|
      puts i
      sleep(0.5)
    end
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
    #this is for temporary buffs to a stat
    # clear
    if stat == "str"
      @str += magnitude.to_i
      if output
        puts "Strength increased by #{magnitude}, it is now #{@str}"
      end
    elsif stat == "con"
      @curHealth += (magnitude.to_i * 3)
      @maxHealth += (magnitude.to_i * 3)
      if output
        puts "Constitution increased by #{magnitude * 3}, max health is now #{@maxHealth}"
      end
    elsif stat == "dex"
      @dex += magnitude.to_i
      if output
        puts "Dexterity increased by #{magnitude}, it is now #{@dex}"
      end
    elsif stat == "int"
      @int += magnitude.to_i
      if output
        puts "Intelligence increased by #{magnitude}, it is now #{@int}"
      end
    end
  end

  def applyBuffs (output = true)
      buffStat(@armor[:head].typeCheck,@armor[:head].instance_variable_get(:@lvl), output)
      buffStat(@armor[:ring].typeCheck,@armor[:ring].instance_variable_get(:@lvl), output)
      buffStat(@armor[:chest].typeCheck,@armor[:chest].instance_variable_get(:@lvl), output)
      buffStat(@armor[:hands].typeCheck,@armor[:hands].instance_variable_get(:@lvl), output)
      buffStat(@armor[:legs].typeCheck,@armor[:legs].instance_variable_get(:@lvl), output)
      buffStat(@armor[:feet].typeCheck,@armor[:feet].instance_variable_get(:@lvl), output)
  end

  def increaseStat(stat,amount)
    #This method is for increasing the baseline of the players stats, not for armor or potions
    if stat == "str"
      @info[:stats][0] += amount
      resetStats
      puts "Strength increased by #{amount}, it is now #{@str}"
    elsif stat == "con"
      @info[:stats][1] += amount
      resetStats
      puts "Constitution increased by #{amount}, it is now #{@con}"
    elsif stat == "dex"
      @info[:stats][2] += amount
      resetStats
      puts "Dexterity increased by #{amount}, it is now #{@dex}"
    elsif stat == "int"
      @info[:stats][3] += amount
      resetStats
      puts "Intelligence increased by #{amount}, it is now #{@int}"
    else
      puts "Stat error"
    end
  end

  def resetStats
    @str = @info[:stats][0]
    @con = @info[:stats][1]
    @dex = @info[:stats][2]
    @int = @info[:stats][3]
    applyBuffs(false)
  end
end
class Character < Entity

  def changeRoom(current)
    puts  "#{current.name} connects to:"
    current.connections.each_with_index do |i, c|
      puts "#{c}.#{i.name}"
    end
    puts "Where do you want to move go?"
    choice = gets.chomp.to_i
    info[:loc] = current.connections[choice].name
    puts "You are in #{current.connections[choice].name}"
  end

  def readSave
    File.open('proj4_save.txt', 'r') do |file|
      file.each_line do |line|
        counter = 0
        line_data = line.split(':')
        if line_data[1].include? "["
          line_data[1].delete! "[]"
          #it's an int
          if line_data[1].include? "^"
            line_data[1].delete! "^"
            @vals = line_data[1].split(",")
            #converts strings read into ints
            @vals.map! {|num| num.to_i}

            @info[line_data[counter].to_sym] = @vals

            #it's a string
            elsif line_data[1].include? "$"
            line_data[1].delete! "$"
            line_data[1].delete! "\n"
            @vals = line_data[1].split(",")
            @vals.map! {|str| str.delete! "/\""}

            @info[line_data[counter].to_sym] = @vals
          end

        else #if it doesnt include "["
          if line_data[1].include? "^"
            line_data[1].delete! "^"
            #converts string read into ints
            @info[line_data[counter].to_sym] = line_data[1].chomp.to_i

            #it's player location
          elsif line_data[1].include? "!"
            line_data[1].delete! "!"
            line_data[1].delete! "\n"
            line_data[1].to_s
            if line_data[1].include? "loc"
              @info[:loc] = line_data[1]
            else
              @info[:room] =  Room.new("#{line_data[1]}","An old dusty room",rand(1..7))
            end

            #it's a string
          elsif line_data[1].include? "$"
            line_data[1].delete! "$"
            line_data[1].delete! "\n"
            @vals = line_data[1].split(",")

            @vals.length.times do |i|
              if @vals[i].downcase.include? "health"
                type = "heal"
                if @vals[i].downcase.include? "lesser"
                  mag = 1
                elsif @vals[i].downcase.include? "greater"
                  mag = 3
                else
                  mag = 2
                end
              elsif @vals[i].downcase.include? "strength"
                type = "str"
                if @vals[i].downcase.include? "lesser"
                  mag = 1
                elsif @vals[i].downcase.include? "greater"
                  mag = 3
                  else
                  mag = 2
                end
              elsif @vals[i].downcase.include? "constitution"
                type = "con"
                if @vals[i].downcase.include? "lesser"
                  mag = 1
                elsif @vals[i].downcase.include? "greater"
                  mag = 3
                  else
                  mag = 2
                end
              elsif @vals[i].downcase.include? "dexterity"
                type = "dex"
                if @vals[i].downcase.include? "lesser"
                  mag = 1
                elsif @vals[i].downcase.include? "greater"
                  mag = 3
                  else
                  mag = 2
                end
              elsif @vals[i].downcase.include? "intelligence"
                type = "int"
                if @vals[i].downcase.include? "lesser"
                  mag = 1
                elsif @vals[i].downcase.include? "greater"
                  mag = 3
                  else
                  mag = 2
                end
              end
              @info[:inventory] << Item.new("item",type,mag,false)
            end

          elsif line_data[1].include? "@"
            line_data[1].delete! "@"
            @vals = line_data[1].delete! "\n"
            if @vals == ""
              @armor[line_data[0].to_sym] = Equipment.new(line_data[0].to_s,"equipment",0,true)
            else
              if @vals.include? "Strength"
                 type = "of Strength"
                elsif @vals.include? "Dexterity"
                 type = "of Dexterity"
                elsif @vals.include? "Constitution"
                 type = "of Constitution"
                elsif @vals.include? "Intelligence"
                 type = "of Intelligence"
               else
                 type = "of Strength"
              end
              @armor[line_data[0].to_sym] = Equipment.new(line_data[0].to_s,type,@vals.scan(/\d+/).first,false)
            end
          end
        end
        counter + 1
      end
    end
  end

  def writeSave
    File.open('proj4_save.txt','w') do |line|
        line.puts "head:@#{@armor[:head].name}"
        line.puts "ring:@#{@armor[:ring].name}"
        line.puts "chest:@#{@armor[:chest].name}"
        line.puts "hands:@#{@armor[:hands].name}"
        line.puts "legs:@#{@armor[:legs].name}"
        line.puts "feet:@#{@armor[:feet].name}"
        line.puts "loc:!#{@info[:loc].name}"
        line.puts "room:!#{@info[:room].name}"

       @info.each do |key, vals|
         if key.to_s != "inventory"
           if key.to_s != "room"
           if  key.to_s != "loc"
             line.puts "#{key}:^#{vals}"
           end
        else
          line.print "inventory:$"
          @info[:inventory].each do |i|
            line.print "#{i.name},"
          end
        end
       end
     end
    end
  end

  def castSpell(targets)
    clear
      loop do
        puts "Who do you want to cast a spell at?"
        list = targets.listEnemies()
        #Only takes integer inputs
        target = Integer(gets) rescue nil
        if (target.is_a? Integer) == true
          if list[target].nil? == true
            clear
            puts "Try again"
          else
            if list[target].health > 0
              clear
              magicAttack(list[target])
              break
            else
              #If your list within the encounter has zero health then it dies
              #The encounter class has removeEnemies method and targets is the encounter
              targets.removeEnemies
              giveExp(10)
              break
              end
            end
          else
            clear
            puts "Try again"
          end#4
      end
  end

  def ability_check(ability,difficulty_class)
    #Str,Con,Dex,Int
    #[0,1,2,3]
    @ability = ability
    @diff_class = difficulty_class
    ability + rand(difficulty_class)
  end

  def addItem(amount,type,mag)
    amount.times do
      @info[:inventory] << Item.new("item",type,mag,true)
    end
  end

  def generateLoot(quant,type)
    potion_type = ["heal","str","dex","con","int"]
    slot_select = ["head","ring","chest","hands","legs","feet"]

    if type == "potion"
      quant.times do
        @loot << Item.new("item",potion_type.sample,1,true)
      end
    elsif type == "armor"
      quant.times do
        @loot << Equipment.new(slot_select.sample,"equipment",1,true)
      end
    else
      puts "Some error"
    end
  end

  def takeLoot
    while @loot.empty? == false do
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
          @info[:inventory] << @loot[choice]
          puts "Added #{@loot[choice].name} to inventory"
          breakLoop = true
          break
        else
          #check equipment
          clear
          loop do
          if @loot[choice].name.downcase.include? "helm"
            if @armor[:head].name == ""
              puts "#{@name} equipped #{@loot[choice].name}"
              @armor[:head] = @loot[choice]
              breakLoop = true
              break
            elsif @armor[:head].name.length > 0
              if switchEquipment(@armor[:head],@loot[choice]) == true
                @armor[:head] = @loot[choice]
                puts "#{@name} equipped #{@loot[choice].name}"
                breakLoop = true
                break
              else
                puts "Item not equipped"
                break
              end
            end
          elsif @loot[choice].name.downcase.include? "ring"
            if @armor[:ring].name == ""
              puts "#{@name} equipped #{@loot[choice].name}"
              @armor[:ring] = @loot[choice]
              breakLoop = true
              break
            elsif @armor[:ring].name.length >= 0
              if switchEquipment(@armor[:ring],@loot[choice]) == true
                @armor[:ring] = @loot[choice]
                puts "#{@name} equipped #{@loot[choice].name}"
                breakLoop = true
                break
              else
                puts "Item not equipped"
                break
              end
            end
          elsif @loot[choice].name.downcase.include? "cuirass"
          if @armor[:chest].name == ""
            puts "#{@name} equipped #{@loot[choice].name}"
            @armor[:chest] = @loot[choice]
            breakLoop = true
            break
          elsif @armor[:chest].name.length > 0
            if switchEquipment(@armor[:chest],@loot[choice]) == true
              @armor[:chest] = @loot[choice]
              puts "#{@name} equipped #{@loot[choice].name}"
              breakLoop = true
              break
            else
              puts "Item not equipped"
              break
            end
          end
          elsif @loot[choice].name.downcase.include? "gauntlets"
          if @armor[:hands].name == ""
            puts "#{@name} equipped #{@loot[choice].name}"
            @armor[:hands] = @loot[choice]
            breakLoop = true
            break
          elsif @armor[:hands].name.length > 0
            if switchEquipment(@armor[:hands],@loot[choice]) == true
              @armor[:hands] = @loot[choice]
              puts "#{@name} equipped #{@loot[choice].name}"
              breakLoop = true
              break
            else
              puts "Item not equipped"
              break
            end
          end
          elsif @loot[choice].name.downcase.include? "greaves"
          if @armor[:legs].name == ""
            puts "#{@name} equipped #{@loot[choice].name}"
            @armor[:legs] = @loot[choice]
            breakLoop = true
            break
          elsif @armor[:legs].name.length > 0
            if switchEquipment(@armor[:legs],@loot[choice]) == true
              @armor[:legs] = @loot[choice]
              breakLoop = true
              puts "#{@name} equipped #{@loot[choice].name}"
              break
            else
              puts "Item not equipped"
              break
            end
          end
          elsif @loot[choice].name.downcase.include? "boots"
            if @armor[:feet].name == ""
              puts "#{@name} equipped #{@loot[choice].name}"
              @armor[:feet] = @loot[choice]
              breakLoop = true
              break
            elsif @armor[:feet].name.length > 0
              if switchEquipment(@armor[:feet],@loot[choice]) == true
                @armor[:feet] = @loot[choice]
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
    if breakLoop == true
      break
    end
    end
    @loot.clear
  end

  def listLoot
    clear
    puts "Choose ONE item to loot, choose wisely"
    @loot.each_with_index do |i, c|
        puts "#{c}. #{i.name}"
    end
    puts
    puts "You have these items equipped:"
    puts "#{@armor[:head].name}"
    puts "#{@armor[:ring].name}"
    puts "#{@armor[:chest].name}"
    puts "#{@armor[:hands].name}"
    puts "#{@armor[:legs].name}"
    puts "#{@armor[:feet].name}"
  end

  def equipArmor(armor)
    if armor.name.downcase.include? "helm"
      if @armor[:head].length == 0
        puts "#{@name} equipped #{armor.name}"
        @armor[:head]
        @armor[:head] = armor
      elsif @armor[:head].length >= 0
        if switchEquipment(@armor[:head][0],armor) == true
          @armor[:head]
          @armor[:head] = armor
          puts "#{@name} equipped #{armor.name}"
        else
          puts "Item not equipped"
        end
      end
    elsif armor.name.downcase.include? "ring"
      if @armor[:ring].length == 0
        puts "#{@name} equipped #{armor.name}"
        @armor[:ring]
        @armor[:ring] = armor
      elsif @armor[:ring].length >= 0
        if switchEquipment(@armor[:ring][0],armor) == true
          @armor[:ring]
          @armor[:ring] = armor
          puts "#{@name} equipped #{armor.name}"
        else
          puts "Item not equipped"
        end
      end
    elsif armor.name.downcase.include? "cuirass"
    if @armor[:chest].length == 0
      puts "#{@name} equipped #{armor.name}"
      @armor[:chest]
      @armor[:chest] = armor
    elsif @armor[:chest].length >= 0
      if switchEquipment(@armor[:chest][0],armor) == true
        @armor[:chest]
        @armor[:chest] = armor
        puts "#{@name} equipped #{armor.name}"
      else
        puts "Item not equipped"
      end
    end
    elsif armor.name.downcase.include? "gauntlets"
    if @armor[:hands].length == 0
      puts "#{@name} equipped #{armor.name}"
      @armor[:hands]
      @armor[:hands] = armor
    elsif @armor[:hands].length >= 0
      if switchEquipment(@armor[:hands][0],armor) == true
        @armor[:hands]
        @armor[:hands] = armor
        puts "#{@name} equipped #{armor.name}"
      else
        puts "Item not equipped"
      end
    end
    elsif armor.name.downcase.include? "greaves"
    if @armor[:legs].length == 0
      puts "#{@name} equipped #{armor.name}"
      @armor[:legs] = armor
    elsif @armor[:legs].length >= 0
      if switchEquipment(@armor[:legs][0],armor) == true
        @armor[:legs]
        @armor[:legs] = armor
        puts "#{@name} equipped #{armor.name}"
      else
        puts "Item not equipped"
      end
    end
    elsif armor.name.downcase.include? "boots"
      if @armor[:feet].length == 0
        puts "#{@name} equipped #{armor.name}"
        @armor[:feet] = armor
      elsif @armor[:feet].length >= 0
        if switchEquipment(@armor[:feet][0],armor) == true
          @armor[:feet]
          @armor[:feet] = armor
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
    @info[:inventory].slice!(@info[:inventory].index(item))
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
    item_used = false
    #2
    while @info[:inventory].empty? == false do
      clear
      puts "What item do you want to use?"
      @info[:inventory].each_with_index do |i, c|
        puts "#{c}. #{i.name}"
      end
      puts "99.Go back"
      choice = Integer(gets) rescue nil
      #3
      if (choice.is_a? Integer) == true
        if choice == 99
          clear
          item_used = false
          break
        end
        #4
        if @info[:inventory][choice].nil? == true
          clear
          puts "Try again"
        else
          itemEffect(@info[:inventory][choice])
          removeItem(@info[:inventory][choice])
          item_used = true
          break
        end#4
      end#3
    end#2
    item_used
  end#1

  def giveExp(amount)
    @info[:exp] += amount
    if @info[:exp]  >= (@info[:level] * 100)
      levelUp
    end
  end

  def levelUp
    clear

    while @info[:exp]  >= (@info[:level] * 100)
      @info[:exp] -= (@info[:level] * 100)
      @info[:level] += 1
      @info[:skpts] += 1
    end
      puts "Level up! You are now level #{@info[:level]}"

      until @info[:skpts] == 0
        choice = 0
        resetStats
        puts "You have #{@info[:skpts]} skill points, what skill do you want to upgrade?"
        puts "1.Strength:#{@str}  2.Constitution:#{@con}  3.Dexterity:#{@dex}  4.Intelligence:#{@int}"
        choice = Integer(gets) rescue nil

        if (choice.is_a? Integer) == true
          if choice == 1
            clear
            increaseStat("str",1)
            @info[:skpts] -= 1
          elsif choice == 2
            clear
            increaseStat("con",1)
            @info[:skpts] -= 1
          elsif choice == 3
            clear
            increaseStat("dex",1)
            @info[:skpts] -= 1
          elsif choice == 4
            clear
            increaseStat("int",1)
            @info[:skpts] -= 1
          else
            clear
          end
        else
          clear
        end
    end
  end

  def noItems
    if @info[:inventory].empty? == true
      true
    else
      false
    end
  end
end
class Encounter
  attr_reader :name, :enemies
  attr_accessor :variable, :enemies

  def initialize(name,rand = false)
    @name = name
    @enemies = Array.new
    @rand = rand

    if rand == true
      type = ["Human","Elf","Iguani","Dwarf"]
      race = type.sample
      amount = rand(1..3)
      @name = "A group of #{race}s"

      amount.times do
        @enemies << Entity.new("warrior1",race)
      end
    end
  end

  def addEnemy(amount,race)
    amount.times do
      @enemies << Entity.new("warrior1",race)
    end
  end

  def removeEnemies
    @enemies.each do |i|
      if i.health <=  0
        @enemies.delete(i)
      end
    end
  end

  def howMany
    @enemies.length
  end

  def listEnemies
    removeEnemies
    @enemies.each_with_index do |i, c|
        puts "#{c}. #{i.name}"
    end
  end

  def enemyAttack(target)
    removeEnemies
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
  attr_reader :name, :type, :magnitude
  attr_accessor :name, :type, :magnitude

  def initialize(name,type,magnitude,new_item)
    @name = name
    @type = type
    @magnitude = magnitude.to_i

    if new_item == true
      randomRoller = rand(1..100)
      if randomRoller <= 70
        magnitude = 1
      elsif randomRoller >= 71 && randomRoller < 92
        magnitude = 2
      else
        magnitude = 3
      end
    end




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

  def getName
    @name
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
  attr_reader :name, :type, :lvl
  attr_accessor :name, :type, :lvl

  def initialize(name,type,lvl,new_item)
    @name = name
    @type = type
    @lvl = lvl
    @new_item = new_item

    if new_item == true
      randomRoller = rand(1..100) + rand(1..100)
      if randomRoller <= 90
        powerLvl = 1
      elsif randomRoller >= 91 && randomRoller < 135
        powerLvl = 2
      elsif randomRoller >= 135 && randomRoller < 160
        powerLvl = 4
      elsif randomRoller >= 160 && randomRoller < 175
        powerLvl = 5
      elsif randomRoller >= 175 && randomRoller < 185
        powerLvl = 6
      elsif randomRoller >= 185 && randomRoller < 192
        powerLvl = 8
      elsif randomRoller >= 192 && randomRoller < 197
        powerLvl = 10
      elsif randomRoller >= 197
        powerLvl = 15
      end
      enchantment = ["of Strength","of Dexterity","of Constitution","of Intelligence"]
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
    else
      if name == "head"
        @name = "Helm " + type + " " + @lvl.to_s

        if type.include? "Strength"
          type = "str"
          elsif type.include? "Dexterity"
          type = "dex"
          elsif type.include? "Constitution"
          type = "con"
          elsif type.include? "Intelligence"
          type = "int"
        end

      elsif name == "ring"
        @name = "Ring " + type + " " + @lvl.to_s

        if type.include? "Strength"
          @type = "str"
          elsif type.include? "Dexterity"
          @type = "dex"
          elsif type.include? "Constitution"
          @type = "con"
          elsif type.include? "Intelligence"
          @type = "int"
        end

      elsif name == "chest"
        @name = "Cuirass " + type + " " + @lvl.to_s

        if type.include? "Strength"
          @type = "str"
          elsif type.include? "Dexterity"
          @type = "dex"
          elsif type.include? "Constitution"
          @type = "con"
          elsif type.include? "Intelligence"
          @type = "int"
        end

      elsif name == "hands"
        @name = "Gauntlets " + type + " " + @lvl.to_s
        if type.include? "Strength"
          @type = "str"
          elsif type.include? "Dexterity"
            @type = "dex"
          elsif type.include? "Constitution"
            @type = "con"
          elsif type.include? "Intelligence"
          @type = "int"
        end

      elsif name == "legs"
        @name = "Greaves " + type + " " + @lvl.to_s

        if type.include? "Strength"
          @type = "str"
          elsif type.include? "Dexterity"
          @type = "dex"
          elsif type.include? "Constitution"
          @type = "con"
          elsif type.include? "Intelligence"
          @type = "int"
        end

      elsif name == "feet"
        @name = "Boots " + type + " " + @lvl.to_s

        if type.include? "Strength"
          @type = "str"
          elsif type.include? "Dexterity"
          @type = "dex"
          elsif type.include? "Constitution"
          @type = "con"
          elsif type.include? "Intelligence"
          @type = "int"
        end
      end
    end
  end
  def typeCheck
    @type
  end
  def nameCheck
    @name
  end
end

#1
def combat(player,enemies)
  player.readSave
  clear
  enemy_count = enemies.howMany
  player.resetStats
  amount_of_exp = enemies.howMany * 15
  puts "You are fighting #{enemies.name}"
  player_turn = true
  #2
  loop do
    #3
    if enemies.howMany <= 0
      break
    else
    #4
    if player.health > 0
      #5
      if player_turn == true
        #Player turn
        puts "1.Cast spell 2.Use item"
        print "What do you do: "
        choice = gets.chomp.to_i
        #6
        if choice == 1
          player.castSpell(enemies)
          player_turn = false
        elsif choice == 2
          if player.noItems == false
            if player.useItem == true
              player_turn = false
            else
              player_turn = true
            end
            else
            clear
            puts "You are out of items"
          end
        else
          clear
          puts "Choose a valid option"
        end #6
      elsif player_turn == false
        #Enemy turn
        puts
        if enemies.howMany > 0
          puts "Enemy turn"
        else
          break
        end
        puts
        enemies.enemyAttack(player)
        player_turn = true
      end #5
    else
      puts "You are dead"
      break
    end#4
    end #3
  end #2
  if player.health > 0
    player.giveExp(amount_of_exp + 30)
    player.generateLoot(enemy_count,"potion")
    player.generateLoot(enemy_count,"armor")
    player.resetStats
    player.takeLoot
    player.writeSave
  end
end #1

# enc1 = Encounter.new("a group of Iguani")
# enc2 = Encounter.new("a group of dwarves")
# enc3 = Encounter.new("a group of elves")
# enc4 = Encounter.new("a group of humans")
#
# #parameters are (amount,racename)
# enc1.addEnemy(3,"Iguani")
# enc2.addEnemy(3,"Dwarf")
# enc3.addEnemy(3,"Elf")
# enc4.addEnemy(3,"Human")
