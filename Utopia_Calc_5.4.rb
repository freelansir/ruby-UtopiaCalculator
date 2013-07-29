class Race
  attr_accessor :attacking_soldier_value, :defending_soldier_value, :attacking_spec_value, :defending_spec_value, :attacking_elite_value, :defending_elite_value
  
  AVIAN_VALUES = [1,1,5,6,7,2] and DWARF_VALUES = [1,1,5,5,7,3] and ELF_VALUES = [1,1,5,6,6,4] and FAERY_VALUES = [1,1,3,5,3,8] and HALFLING_VALUES = [2,2,5,5,5,6] and HUMAN_VALUES = [1,1,6,5,5,5] and ORC_VALUES = [1,1,5,5,9,2] and UNDEAD_VALUES = [1,1,5,5,9,3]
  
  def initialize(race)
    @races = {"avian" => AVIAN_VALUES, "dwarf" => DWARF_VALUES, "elf" => ELF_VALUES, "faery" => FAERY_VALUES, "halfling" => HALFLING_VALUES, "human" => HUMAN_VALUES, "orc" => ORC_VALUES, "undead" => UNDEAD_VALUES}           
    self.attacking_soldier_value, self.defending_soldier_value, self.attacking_spec_value, self.defending_spec_value, self.attacking_elite_value, self.defending_elite_value = @races[race][0], @races[race][1], @races[race][2], @races[race][3], @races[race][4], @races[race][5]
  end
  
  def display
    puts "#{self.attacking_soldier_value}/#{self.defending_soldier_value} ==> Soldier"
    puts "#{self.attacking_spec_value}/#{self.defending_spec_value} ==> Specialist"
    puts "#{self.attacking_elite_value}/#{self.defending_elite_value} ==> Elite"
  end
end

class Army
  attr_accessor :soldiers, :defence_specs, :offence_specs, :elites, :warhorses, :prisoners, :mercs, :town_watch, :military_effectiveness, :generals, :race, :personality

  def initialize(soldiers, defence_specs, offence_specs, elites, warhorses, prisoners, mercs, town_watch, military_effectiveness, generals, race, personality)
    self.soldiers, self.defence_specs, self.offence_specs, self.elites, self.warhorses, self.prisoners, self.mercs = soldiers, defence_specs, offence_specs, elites, warhorses, prisoners, mercs
    self.town_watch, self.military_effectiveness, self.generals = town_watch, military_effectiveness, generals
    self.race, self.personality = race, personality
  end

  def display_defending_count
    puts "#{self.soldiers} ==> Soldiers"
    puts "#{self.defence_specs} ==> Defence Specs"
    puts "#{self.elites} ==> Elites"
    puts "#{self.military_effectiveness} ==> Military Effectiveness"
    puts "#{self.town_watch} ==> Town Watch Spell"
  end

  def raw_defensive_strength
    (self.soldiers * self.race.defending_soldier_value) + (self.defence_specs * race.defending_spec_value) + (self.elites * race.defending_elite_value) + self.town_watch       
  end

  def modified_defensive_strength
    raw_defensive_strength * self.military_effectiveness
  end    
  
  def display_defensive_strength
    puts "#{raw_defensive_strength.round} ==> Raw Defensive Strength"
    puts "#{modified_defensive_strength.round} ==> MODIFIED DEFENSIVE STRENGTH"
  end 
    
  def display_attacking_count
    puts "#{self.soldiers} ==> Soldiers"
    puts "#{self.offence_specs} ==> Offence Specs"
    puts "#{self.elites} ==> Elites"
    puts "#{self.warhorses} ==> Warhorses"
    puts "#{self.prisoners} ==> Prisoners"
    puts "#{self.mercs} ==> Mercs"    
    puts "#{self.military_effectiveness} ==> Military Effectiveness"
    puts "#{self.generals} ==> General Bonus"
    puts "#{self.personality} ==> Warrior Bonus"
  end
   
  def raw_offensive_strength
    (self.soldiers * self.race.attacking_soldier_value) + (self.offence_specs * self.race.attacking_spec_value) + (self.elites * self.race.attacking_elite_value) + (self.warhorses * 1) + ((self.prisoners + self.mercs) * 3)
  end
  
  def combined_offensive_multipliers
    (self.military_effectiveness + (self.generals - 1)) * self.personality
  end    

  def modified_offensive_strength
    def modified_soldier_offensive_strength
      self.soldiers * self.race.attacking_soldier_value * combined_offensive_multipliers 
    end
    def modified_offence_spec_offensive_strength
      self.offence_specs * self.race.attacking_spec_value * combined_offensive_multipliers
    end
    def modified_elite_offensive_strength
      self.elites * self.race.attacking_elite_value * combined_offensive_multipliers
    end
    def modified_warhorse_offensive_strength
      self.warhorses * 1 * combined_offensive_multipliers
    end
    def modified_prisoner_offensive_strength
      self.prisoners * 3 * combined_offensive_multipliers
    end
    def modified_merc_offensive_strength
      self.mercs * 3 * combined_offensive_multipliers
    end
    return modified_soldier_offensive_strength + modified_offence_spec_offensive_strength + modified_elite_offensive_strength + modified_warhorse_offensive_strength + modified_prisoner_offensive_strength + modified_merc_offensive_strength
  end
  
  def display_offensive_strength
    puts "#{raw_offensive_strength.round} ==> Raw Offensive Strength"
    puts "#{combined_offensive_multipliers} ==> Combined Offensive Multipliers"
    puts "#{modified_offensive_strength.round} ==> MODIFIED OFFENSIVE STRENGTH"
  end
end

class Battle
  attr_accessor :risk_profile, :soldiers_fight, :offence_specs_fight, :elites_fight, :warhorses_fight, :prisoners_fight, :mercs_fight, :race, :defending_army, :attacking_army       
  
  def initialize(risk_profile, soldiers_fight, offence_specs_fight, elites_fight, warhorses_fight, prisoners_fight, mercs_fight, race, defending_army, attacking_army)   
    self.risk_profile, self.soldiers_fight, self.offence_specs_fight, self.elites_fight, self.warhorses_fight, self.prisoners_fight, self.mercs_fight = risk_profile, soldiers_fight, offence_specs_fight, elites_fight, warhorses_fight, prisoners_fight, mercs_fight
    self.race, self.defending_army, self.attacking_army = race, defending_army, attacking_army  
  end
  
  def required_offensive_strength
    defending_army.modified_defensive_strength * self.risk_profile
  end

  def offence_vs_defence_strength
    attacking_army.modified_offensive_strength - required_offensive_strength
  end  
    
  def display_required_strength  
    puts "#{defending_army.modified_defensive_strength.round} ==> Modified Defensive Strength"
    puts "#{attacking_army.modified_offensive_strength.round} ==> Modified Offensive Strength"
    puts "#{required_offensive_strength.round} ==> REQUIRED OFFENSIVE STRENGTH"
    if offence_vs_defence_strength > 0 then puts "#{offence_vs_defence_strength.round} ==> EXTRA OFFENCE" elsif offence_vs_defence_strength < 0 then puts "#{offence_vs_defence_strength.round} ==> MISSING OFFENCE" end
  end
  
  def optimal_unit_mix_count
    if required_offensive_strength < self.attacking_army.modified_offence_spec_offensive_strength
      self.offence_specs_fight = required_offensive_strength / ((self.race.attacking_spec_value) * self.attacking_army.combined_offensive_multipliers)
      required_offensive_strength_1 = required_offensive_strength - self.offence_specs_fight * (self.race.attacking_spec_value) * self.attacking_army.combined_offensive_multipliers
    else
      required_offensive_strength_1 = required_offensive_strength - self.offence_specs_fight * (self.race.attacking_spec_value) * self.attacking_army.combined_offensive_multipliers
    end
    
    if required_offensive_strength_1 < self.attacking_army.modified_elite_offensive_strength
      self.elites_fight = required_offensive_strength_1 / ((self.race.attacking_elite_value) * self.attacking_army.combined_offensive_multipliers)
      required_offensive_strength_2 = required_offensive_strength_1 - self.elites_fight * (self.race.attacking_elite_value) * self.attacking_army.combined_offensive_multipliers
    else
      required_offensive_strength_2 = required_offensive_strength_1 - self.elites_fight * (self.race.attacking_elite_value) * self.attacking_army.combined_offensive_multipliers
    end

    if required_offensive_strength_2 < self.attacking_army.modified_soldier_offensive_strength
      self.soldiers_fight = required_offensive_strength_2 / self.attacking_army.combined_offensive_multipliers
      required_offensive_strength_3 = required_offensive_strength_2 - self.soldiers_fight * self.attacking_army.combined_offensive_multipliers
    else
      required_offensive_strength_3 = required_offensive_strength_2 - self.soldiers_fight * self.attacking_army.combined_offensive_multipliers
    end
    
    if required_offensive_strength_3 < self.attacking_army.modified_prisoner_offensive_strength
      self.prisoners_fight = required_offensive_strength_3 / self.attacking_army.combined_offensive_multipliers
      required_offensive_strength_4 = required_offensive_strength_3 - self.prisoners_fight * self.attacking_army.combined_offensive_multipliers
    else
      required_offensive_strength_4 = required_offensive_strength_3 - self.soldiers_fight * self.attacking_army.combined_offensive_multipliers
    end
    
    if required_offensive_strength_4 < self.attacking_army.modified_merc_offensive_strength
      self.mercs_fight = required_offensive_strength_4 / self.attacking_army.combined_offensive_multipliers
    end
    
    optimal_unit_count = self.soldiers_fight + self.offence_specs_fight + self.elites_fight
    self.warhorses_fight = optimal_unit_count if self.warhorses_fight > optimal_unit_count 
  end
  
  def optimal_unit_mix_strength  
    ((self.soldiers_fight * self.race.attacking_soldier_value + self.offence_specs_fight * self.race.attacking_spec_value + self.elites_fight * self.race.attacking_elite_value + self.warhorses_fight * 1 + self.prisoners_fight * 3 + self.mercs_fight * 3) * attacking_army.combined_offensive_multipliers)
  end
  
  def oversend_percentage  
    (optimal_unit_mix_strength / required_offensive_strength)
  end
  
  def display_optimal_unit_mix_count
    puts "#{self.soldiers_fight.round} ==> Soldiers"
    puts "#{self.offence_specs_fight.round} ==> Offence Specs"
    puts "#{self.elites_fight.round} ==> Elites"
    puts "#{self.warhorses_fight.round} ==> Warhorses"
    puts "#{self.prisoners_fight.round} ==> Prisoners"
    puts "#{self.mercs_fight.round} ==> Mercs"
    puts "#{optimal_unit_mix_strength.round} ==> MODIFIED OFFENSIVE ARMY STRENGTH"
    puts "#{oversend_percentage} ==> OVERSEND PERCENTAGE"
  end
end
       
def welcome
  puts "Please choose your calculator type: (defense/offence/attack)"
  input = gets.chomp
  if input == "defense" or input == "d" then defense_calc elsif input == "offence" or input == "o" then offence_calc elsif input == "attack" or input == "a" then attack_calc end
end

def defense_calc
puts "Please enter the defending race:"
race_input = gets.chomp
defending_race = Race.new(race_input)
defending_race.display
  
puts "Please enter the number of defending soldiers:"
defending_soldiers_count = gets.to_i
puts "Please enter number of defensive specs:"  
defending_defence_specs_count = gets.to_i
puts "Please enter number of defending elites:"  
defending_elites_count = gets.to_i

puts "Target Military Effectiveness? (100 = 100%)"  
input = gets.to_f
defending_military_effectiveness = input / 100

defending_town_watch = 0
if race_input == "avian" or race_input == "faery" then puts "Does the target have Town Watch? (true/false)"                               
  input = gets.chomp  
  if input == "true" then puts "How many peasants does the target have?" 
    defending_town_watch = gets.to_i / 4
  end
end   

defending_army = Army.new(defending_soldiers_count, defending_defence_specs_count, 0, defending_elites_count, 0, 0, 0, defending_town_watch, defending_military_effectiveness, 1, defending_race, 1)
         
defending_army.display_defending_count 
defending_army.raw_defensive_strength 
defending_army.modified_defensive_strength 
defending_army.display_defensive_strength

welcome
end

def offence_calc
puts "Please enter the attacking race:"
input = gets.chomp
attacking_race = Race.new(input)
attacking_race.display

puts "Please enter the number of attacking soldiers:"
attacking_soldiers_count = gets.to_i
puts "Please enter number of offensive specs:"  
attacking_offence_specs_count = gets.to_i
puts "Please enter number of attacking elites:"  
attacking_elites_count = gets.to_i
puts "Please enter number of warhorses:"  
attacking_warhorses = gets.to_i
puts "Please enter number of prisoners:"  
attacking_prisoners = gets.to_i
puts "Please enter number of mercs:"  
attacking_mercs = gets.to_i

attacking_unit_count = attacking_soldiers_count + attacking_offence_specs_count + attacking_elites_count
attacking_warhorses = attacking_unit_count if attacking_warhorses > attacking_unit_count
                                                                                                
puts "Your Military Effectiveness? (100 = 100%)"  
attacking_military_effectiveness = gets.to_f

puts "Please enter number of generals to send:"  
input = gets.to_i
attacking_generals = 1 + (input - 1) * 0.03

puts "Is your personality Warrior? Are you in War? (true/false)"  
input = gets.chomp
if input == "true" then attacking_personality = 1.1 else attacking_personality = 1.0 end

attacking_army = Army.new(attacking_soldiers_count, 0, attacking_offence_specs_count, attacking_elites_count, attacking_warhorses, attacking_prisoners, attacking_mercs, 0, attacking_military_effectiveness / 100, attacking_generals, attacking_race, attacking_personality)

attacking_army.display_attacking_count 
attacking_army.raw_offensive_strength 
attacking_army.combined_offensive_multipliers
attacking_army.modified_offensive_strength
attacking_army.display_offensive_strength

welcome
end

def attack_calc 
puts "What is your risk profile? (risky = 2.5%, safe = 5%, oversend = 10%)"
input = gets.chomp
if input == "risky" then risk_profile = 1.025 elsif input == "safe" then risk_profile = 1.05 elsif input == "oversend" then risk_profile = 1.1 end

battle = Battle.new(risk_profile, attacking_soldiers_count, attacking_offence_specs_count, attacking_elites_count, attacking_warhorses, attacking_prisoners, attacking_mercs, attacking_race, defending_army, attacking_army)
 
battle.required_offensive_strength  
battle.offence_vs_defence_strength  
battle.display_required_strength 
battle.optimal_unit_mix_count 
battle.optimal_unit_mix_strength
battle.display_optimal_unit_mix_count
end

welcome