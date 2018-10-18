Neverwinter Nights 2, The Complete Craftsman Reboot
Formerly known as Neverwinter Nights 2, The Complete Craftsman MotB Patch + Rebalance [Reboot]
Game Version: 1.23 Complete from GoG.com (tested), but probably works on other versions as well.
Patch Version: 2.05
Original The Complete Craftman Mod By: ChainsawXIV
Previous Patch Credit: Jake Zahn/Offkorn
Current Patch by: Vandervecken Smith & KevL
Date: TBD

NOTE:
This new version (2.0 onwards) is fully self-contained and should not be installed on top of the original TCC.
It repackages many original elements of the TCC, but the code has been majorly overhauled, primarily by KevL.
HTML documentation from the original TCC is included with ChainsawXIV's permission.
You can also find this documentation online at completecraftsman.com


--------------------
Installation
--------------------

1. Extract the 'TCC' folder contained in this archive into the Override folder located within your
   'My Documents/Neverwinter Nights 2' directory. 'The Rebalanced Crafting Recipes.txt' file lists the available recipes.
   If you wish to use the area_override file, you must extract it too.

2. If you want to use the original TCC recipes, as closely as possible, remove the crafting.2da and crafting_index.2da files, 
   and rename the crafting_original.2da and crafting_index_original.2da to crafting.2da and crafting_index.2da respectively.
   You can find the original recipes here: http://completecraftsman.com/, 
   or in the included 'The Complete Craftsman - Original Recipe List.htm' file
   
Installing in mid-game:
I don't think there is any risk to installing this in mid-game, as long as there are no other mods that change the same scripts.
A word of caution about item blueprints: Item blueprints are used at the moment an item is created, so the item blueprint
overrides in this mod will not replace existing items. Items are created through crafting, but also at the moment you first
enter any area. So if you install these item overrides they will only affect newly forged items, and items found in areas
you have not yet visited.
   
--------------------
Description
--------------------

This mod overhauls and reboots the Complete Craftsman Mod, by ChainsawXIV, to work correctly with Mask of
the Betrayer installed (as well as many other fixes). If you do NOT have Mask of the Betrayer installed, then using these files may
cause bugs and you would probably be best off using the regular 1.13 version of the Mod.

The Complete Craftsman Mod v1.13 can be found here: 

https://neverwintervault.org/project/nwn2/hakpak/complete-craftsman

The 2.0 version of the mod contains major reorganizations and streamlining of the code in the TCC. 
It maintains the core concepts and structure and functionality of the TCC, but with much improved internals.

You can find the source code for this mod on GitHub at: https://github.com/kevL/TccScripts

The base version of this mod is the "Rebalanced" edition, which contains the many recipe changes made by Jake Zahn in the original
"Complete Craftsman MotB-SoZ Patch and Rebalance" mod, as well as a few of my own. See the Rebalanced Recipe Changelog for details.
If you wish to use recipes that adhere most closely to the original TCC, you may use the original crafting.2da and crafting_index.2da files.
See the Installation section of this Readme for more details.
We recommend the Rebalanced version.

NOTE: All the standard MotB recipes from the vanilla game are included.

To install this patch, you do not need to download the original TCC, or Jake's "Complete Craftsman MotB-SoZ Patch and Rebalance" mod.
This mod is a complete re-release.

The code is now threaded through with detailed debugging output to the ingame chat window.
To turn on detailed debugging to the ingame chat window, go into "ginc_crafting.nss" and set the TELLCRAFT constant at the top of the file (line 37).
After this, you will need to recompile the TCC .nss scripts in the NWN 2 toolset.

Regarding Exotic Materials:
In v2.0 we have undertaken a major review and update of the way crafting with exotic materials is treated.
We have edited the Item Blueprint files (*.UTI) to make them more consistent, and we have detailed what each material provides in the Recipe Readme.
These changes apply to the vanilla and "Rebalanced" versions of this mod, since they are not recipe changes. 
We have also added Item Blueprints in a "Template Overrides" folder. These items override items found in the base game.
For example, Zalantar Quarterstaffs now do +1 Magical damage, like Zalantar Clubs and Spears.
In vanilla NWN 2 Zalantar Quarterstaffs added +1 Electrical damage. The Masterwork Zalantar Quarterstaff in the Templates folder
is a new item with +1 Magical damage. The Zalantar Quarterstaff in the Template Overrides replaces the vanilla NWN 2 item for consistency.

--------------------
Exotic Materials
--------------------

TCC allows you to create a number of items using exotic materials not possible
in vanilla NWN 2. There are some important complexities to bear in mind:
* Exotic Materials grant their items a pre-determined set of bonuses, that use
  enchantment slots. These bonus properties can be upgraded but not removed.
* When you craft weapons and armor (torso armor and shields) using exotic materials
  those items get special bonus slots that offset the pre-determined properties.
* When you craft other items using exotic materials, there are no special
  bonus slots like with armor and weapons. As such, you can craft items that
  have no free enchantment slots available.

In order to rationalize the effects of exotic materials, there are a number of 
UTIs in the Template Overrides folder that replace item blueprints in the
vanilla game. Using these is strictly optional.
  
The properties of each exotic item is listed below:
Fire Mephit Hide - Base Weight Reduction 20%, Fire Resistance 5
Ice Mephit Hide - Base Weight Reduction 20%, Cold Resistance 5
Red Dragon Hide - AC +3 (Armor & Shields) or Fire damage 2 (Gloves), Base Weight Reduction 80%, Fire Resistance 20
Salamander Hide - AC +1 (Armor), Base Weight Reduction 60%, Fire Resistance 10
Umber Hulk Hide - AC +2 (Armor & Shields), Immunity to Mind-Affecting Spells
				  +1 attack (Slings)
Winter Wolf Hide - Base Weight Reduction 40%, Cold Resistance 10,
				   +1 attack (Slings)
Wyvern Hide - AC +2 (Armor & Shields), Base Weight Reduction 80%, Save vs Poison +4

Duskwood - Base Weight Reduction 40%, +3 attack (Crossbows), Mighty +6 (Bows)
Ironwood - Base Weight Reduction 40%, Arcane Spell Failure -5% (Shields),
		   +1 attack (Melee weapons)
Shederran - +2 attack (Crossbows), Mighty +4 (Bows)
Zalantar - Arcane Spell Failure -10% for Heavy & Tower Shields, -5% for Light Shields.
		   AC +2 for all Shields, +1 Magical damage for Melee weapons
		   +1 attack (Crossbows), +2 Mighty (Bows)

Alchemical Silver & Cold Iron - No specific bonuses
Adamantine - Damage Resistance 1/- (Light Armor & Light Shields),
			 2/- (Medium Armor & Heavy Shields),
			 3/- (Heavy Armor & Tower Shields)
			 Magical damage 2 (Gauntlets, Melee weapons, Ammunition)
Darksteel - Acid Resistance 5 (Armor, Shields, Helms),
			Electrical damage 1 (Gloves, Melee weapons, Ammunition)
Mithral - Base Weight Reduction 60% (Weapons)
Mithral Armor & Shields are a special case: Instead of Item Properties they
are categorized as completely different armor types. In general, they gain:
Weight reduced by ~50%
Max Dex Bonus increased by 2
Armor Check Penalties lessened by 3
Arcane Spell Failure decreased by 10%
Heavy Armor becomes Medium, Medium Armor becomes Light
NOTE: Mithral Armor Masterwork bonuses function correctly, but they are not reflected in the item description text. This is an issue
 with the dialog.tlk not supporting Masterwork Mithral armor. 

--------------------
Version changes
--------------------

Version 2.05
- Fixed Divine Level 4 Spells on Armor to use the right ingredients
- Fixed Cleric Bonus Spell enhancements for Levels 3,4,5
- Fixed Appraise +4 enhancement recipe
- Fixed Hypothermia Bolt recipe to make Bolts of Frostbite not Bolts of Lightning
- Staff of Ashenwood in MotB uses Mold Spirit spell and now requires Mold Spirit feat, not Malleate Spirit Feat.
- Removed an old recipe for Slay Living vs Undead on a weapon that is superceded by a TCC recipe
- Added documentation for Slay Dwarves/Elves/Half-Elves to the Readme
- Fixed Slay Outsiders enhancement to work with Slay Living as well as Finger of Death
- Deleted the Lucky recipe on Weapons. This will never work as intended because in NWN2 Luck bonuses don't stack, 
  and items like the Luckstone are implemented with a very large number of properties, which is undesireable when enchanting.
- Added missing recipe for Spell Focus (Transmutation)
- improvements to the tcc_scanner
- Miscellaneous bugfixes

Version 2.04
- Fixed Readme error where Acid Splash was used for Melee weapon acid damage recipes. The Readme now correctly reflects
  that the recipe uses Melf's Acid Arrow.
- Fixed Readme to remove Cold Iron and Alchemical Silver from helmet/hat recipes.
- Fixed Darksteel Helmet Recipe to now make Darksteel Helmet
- Fixed Iron Helmet recipe to work correctly
- Fixed Arrow of Detonation recipe using Perfected Thunderstone and Alchemit's Fire to work correctly

Version 2.03
- Fixed bug with recipe accidentally being read as Set Recipe.

Version 2.02
- Storm of Zehir trade system works again

Version 2.01
- Mortar & Pestle now works correctly
- Changed the way Propsets are read from the crafting.2da to remove the need for a config variable
- Disabled the recipes for Physical Damage Reduction on items. They don't work and never have. It's a core code issue.
  For further details see discussion here: http://nwn2.wikia.com/wiki/Armor_recipes

Version 2.0
- Major code reorganization
- Threaded the code with debug messages. See the Description section for more details.
- Warlocks using Imbue Item now can craft items. When the same recipe can create different properties based on the spell, 
  a new dialog box enables the player to select which spell they wish to use.
- Overhauled the way property slots are calculated. Multi-property recipes may now only be used on items that have enough property slots to accommodate all
  non-upgrade non-free properties.
- Masterwork Weapons that are enchanted with Enhancement bonuses now have their Masterwork attack bonuses overwritten.
- Fixed Masterwork Duskwood Club UTI that had a typo
- A new item, the "tcc-scanner", is available for in-game use. It scans an item and tells you the item properties on it. 
  You can access it from the console with the command "giveitem tcc_scanner"
- Added a new toggle to tcc_config.2da to allow Epic level characters (lvl 21+) to have bonus slots when enchanting (as was in the original game).
  The default value is 0 bonus slots.
- Fixed the Universal Resistance (Saving Throw) recipes to work correctly
- Acid Splash recipes now work correctly
- Fixed the Readme to reflect which crafting materials receive bonus slots
- Granted Duskwood the bonus slot when making ranged weapons, due to it making the best bows, much better than Zalantar
- No matter how many Limitation properties you enchant an item with, you only get one bonus slot for limitations.
- Added Limitation recipes to the Crafting Recipes file, although they always worked just like in the original TCC
- Universal recipes (TCC tag -1) now work on Melee weapons again.
- Increased Caster level requirement for Stat-boosting items from 8/8/8 to 8/14/17 for +4/+6/+8 items.
  This applies to: Nymph Cloak, Headband of Intellect, Periapt of Wisdom, Belt of Giant Strength, Boots of Striding, Belt of Agility
- Fixed a typo in the description of the Constitution +4 recipe - the wrong gem was noted - it's a Jacinth not a Star Sapphire
- Fixed the Crafting Recipes file for +1/+2/+3 deflection recipes for weapons. It now reflects the correct caster levels.
- Added a Limitation Recipe for Warlocks (Rebalanced only), as they were the only base class without one.
- Set properties work again. Some discussion of the details in the Rebalanced Crafting Recipes file.
- Winter Wolf, Fire and Ice Mephit exotic materials now provide bonus properties to cover their inherent bonuses
- Major overhaul of blueprint items for increased consistency and correctness when crafting exotic materials. See Rebalanced Crafting Recipes for additional discussion


Version 1.19
- Modified new Myrkul's Wrath recipe to work. Now uses 2 adamantine ingots instead of one Adamantine Scythe
- Modified Ring of the Founder/Red Wizards recipes to work with Mithral ingots correctly.

Version 1.18 (first Vandervecken Smith Version)
- Recipes that take up no slots can be used on items that are already fully enchanted
- Amulet of Betrayal Personified now works with any four companion essences
- Bracers of Armor +8 can now be made correctly with Shield of Faith
- Recipes requiring Mold Spirit no longer require the other crafting feats to perform
- Recipes placing multiple properties on an item now work correctly
- Effects that hurt the player now no longer count against enchantment limit
- Fixed a lot of recipes due to mis-numbering of the crafting_index file
- Fixed Shocking Weapon recipes to correctly reflect the Readme
- Fixed Spell Failure recipes with Star Sapphire
- Fixed Universal Saving Throw recipes
- Added a bonus slot to Masterwork Weapons with Attack Bonus +1, so Masterwork Weapons now get the Attack Bonus +1 free, as well as getting a bonus enchantment slot
- Restored the ability of True Seeing to be used on the same item types it used to be usable on. This fixes the Blessing of Mystra in MotB
- Applying Shape of Fire or Shadow of the Void Essences to your weapons will now give free Fire and Cold VFX respectively

Version 1.176
- Corrected information on universal Strength Bonus recipes
- Fixed +2 Strength Bonus recipe

Version 1.175
- Fixed Universal Saving Throw Bonus recipes

Version 1.174
- Shock Weapon/Gloves now use Diamond instead of Canary Diamond
- Sonic Weapon/Gloves now use Diamond instead of Star Sapphire
- Fixed Arcane Spell Failure Reduction recipes

Version 1.173
- Frost Weapon/Gloves now use Sapphire instead of Star Sapphire (no clue what I was thinking there)

Version 1.172
- Basic Armor Enhancement recipes now correctly accept Magic Vestment

Version 1.171
- Dash/Toughness recipes now correctly use Beljuril

Version 1.17
- Fixed Ranged Weapon recipes

Version 1.168
- Updated two 2da files for SoZ

Version 1.167
- Added Spint Mail mold, templates, and recipes
- Changed Chain Lightning Cast-on-Hit armor recipe to Shocking Grasp

Version 1.166
- Fixed several faulty Glove recipes
- Altered descriptions for a few in-game crafting books

Version 1.165
- Added Salamander/W.Wolf Hide Gloves recipes
- Added Wyvern Hide L/H/T Shield recipes
- Fixed Poison Arrow/Bolt blacksmith recipes
- Fixed Salamander Hide Clothing descriptions

Version 1.164
- Added Mephit Hide gloves
- Added missing Gauntlet/Helmet recipes
- Fixed doubled stats in the Masterwork Armor descriptions
- Fixed incorrect Gauntlet appearance
- Updated Mephit/W.Wolf Hide clothing descriptions.

Version 1.163
- Fixed the three added distillation recipes
- Fixed the Lightning Arrows/Bolts blacksmith recipes
- Changed the icon on the Sling/Dart Molds to better match the other added molds

Version 1.162
- Added Dragonhide shields
- Added missing Masterwork versions of the Ironwood Shields
- Fixed faulty +Skill and Cast-on-Hit recipes
- Light Shields now only require one Ingot/Plank/Hide
- Zalantar Heavy Shield now gets +2 AC

Version 1.161
- Added an additional Cast-on-Hit spell level
- Added Ironwood Spear and Shield recipes
- Reduced Dragonhide Gauntlets power
- Spread out Cast-on-Hit recipes a bit (4/8/12/16/20)

Version 1.16
- Added several new Clothing and Padded Armor recipes
- Added 2 Magic Damage to Adamantine Gauntlets
- Added Darksteel and Red Dragon Hide Gauntlets
- Added three Sling recipes
- Added three slay-on-Hit recipes
- Added a significant number of Cast-on-Hit recipes for Armor/Weapons
- Added FullStacking functionality to Magician Workbench Ammo Crafting
- Changed several Cast-Spell Universal recipes
- Changed Purple Light Universal recipes
- Changed Quick Armor recipe
- Changed Padded Armor recipe
- Disabled Adamantine Jewelry recipes
- Removed added Bow/Crossbow and Robe recipes
- Removed Dragonhide Clothing recipes

Version 1.156
- Fixed Ammo FullStacking (yet again)
- Fixed faulty weapon recipes (crafting.2da categories issues)
- Fixed Throwing Axe recipes (now correctly use 2 ingots)
- Fixed Keen recipe
- Altered Massive Critical and Keen recipe spell requirements
- Reduced Silence-on-Hit recipe difficulty to 20
- Added multiple recompiled scripts that have ginc_crafting as an #include
- Added Complete Recipe listing .txt file

Version 1.155
- Fixed non-masterwork ammunition FullStacking
- Removed Alchemical Ammo recipes due to FullStacking issues
- Alchemical Blacksmith recipes should now work (who knew capitalization mattered?)
- Added specific re-compiled MotB scripts that may or may not do anything noticable

--------------------
Contact
--------------------

I (Vandervecken Smith) have built upon Offkorn's original mod and am happy to provide further bugfixes if any are needed.

E-Mail: vanderveckensmith@gmail.com
