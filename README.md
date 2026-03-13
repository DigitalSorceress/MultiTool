# MultiTool:ReadMe
- Version: 10.0.4.001
- Date: 2026/03/11
- Author: DigitalSorceress

## SUMMARY
MultiTool: A set of quality of life tools to help make folks who quest together's lives a bit easier.

## Rebooting the Addon
I stopped playing Warcraft several expansions ago, but have gotten back into it, thus I resurrected this addon.

Been active in fixing bugs from API changes since I last updated.

Added my first new feature in years: Auto Accept Invite for in my own guild

Its a new option (on by default) that if auto accept group is true AND you've selected the guild override option, it will not bother checking whitelist

I'll add more of this and likely battlenet friend stuff soon

## New Repo Home
I have nothing against curseforce/wowace but I never cared much for the subversion repo used by wowace.

This addon is not officialy hosted at [my github](https://github.com/DigitalSorceress/MultiTool)

There are going to be quite a few quick checkins there if you want the latest

The addon itself will continue to be updated at [curseforge](https://www.curseforge.com/wow/addons/multitool)

## HISTORY / INSPIRATION
This addon was originally created to assit me with multiboxing (using 2 or 3 accounts at once) WotLK phasing made multi-boxing harder and harder as it constantly broke follow etc. I stopped multi-boxing but found that this addon was still very useful for folks questing together and for the few little quality of life enhancements like auto sell gray and auto reject duel etc, so I kept it going

As someone who used to dual / triple box all the time, I have found a lot of little bits and pieces in the addon world that help take some of the drudgery out of multiple invites, turnins, quest gossips, yada yada. Often times, I find I am installing a whole addon just for one small feature, leading to a lot of overhead. I decided that Enough is enough.

This addon was inspired by Smurfy's MultiBox v2 which has a great collection of really useful stuff. If MultiBoxer was Ace3 or used a more lightweight approach, I'd probably just contribute and/or make a fork. Instead, I've decided to try my hand at a ground-up, exactly-what-I-want, lightweight Ace3-based addon.

I'd also like to acknowledge "Zanthor's Quest Broadcaster" for giving me a road map for quest gossip cloning.


## ABOUT 'MASTERLESS' TOOLS
A lot of the available addons for multi boxers seem to use the concept of a "master".. Makes sense I suppose, after, all, you tend to play one toon (master) and have all the others (slaves) follow you and do stuff when your master does.

This is all well and good, but I often find that when not in combat, (quest pickup/turnin, flight masters, etc...) I may want to be taking lead on a different toon. (cuz I happen to be on that mouse/kbd for some reason).

So, I designed a system for flightmasters and quest givers where all you do is open the npc dialog on all your toons, then pick the option on ANY ONE and the others follow you.

NOTE: I deliberately do NOT clone quest reward choices on the grounds that I run three different classes and want to pick that myself. I may put in an option for "total clone" where that is allowed, but for now, you gotta pick your rewards manually.


## FEATURE ROAD MAP
I've got a LOT of little things I'd like to do with this addon over time. Some of these may be impractical or not really end up being what I wanted. They are listed here somewhat in the order I want to build them in.

### IMPLEMENTED
- Warn on losing AutoFollow - Implemented v0.3.05
  This was due to a suggestion from jst-one from www.dual-boxing.com forums
  
  The Party Options config is starting to get kind of big... may need to re-think that a bit

- Auto Accept Resurrect - Implemented v0.3.04
  Adding config options and event handling

- Custom Sounds - Implemented v0.2.05
  Customizable warning sounds for various events

- BLIZ Addon Config compatible - Implemented v0.1.02
  Will properly integrate into the new Blizard addon configuration pages

- Profile support - Implemented v0.2.04
  Will use profile-type system to allow for easy customization per toon/account

- WhiteList - Implemented v0.2.04
  define one or more toons in a list for use in invites, taxi following, auto trade, etc that require a high degree of trust (More than just general friends list) Possibly define permissions (canAutoTrade, canChooseTaxi, canAutoInvite, etc...)

- Auto Deny duel requests - Implemented v0.1.02
  Maybe MAYBE allow whitelist to request dual - though dueling dualboxers seems a bit Freudian to me

- Taxi Dispatcher - Implemented v0.1.03
  Allows other toons in your group with the addon to automatically take the same taxi node as you

- Quest Log Full alert - Implemented v0.2.00
  Some kind of sound/warning to other members of group with addon if a toon's quest log is close to full

- Bags full warning - Implemented v0.2.00
  Some kind of sound/warning to other members of group with the addon that bag space is low/empty

- Auto Accept Group Invite - Implemented v0.2.04
  Able to auto accept group invites from those on your white list

- Auto Repair - Implemented v0.2.00
  When a toon with the addon opens a dialog with a repair vendor, it will attempt to repair all

- Auto Repair Announce - Implemented v0.2.07
  When Auto Repair has caused you to spend money, it will announce amount spent to other MultiTool users in your party. Configurable for self-only or broadcast and with sound.

- Quest Gossip Share - Implemented v0.1.06
  Allows other toons in your group with the addon to copy your choices on quest dialogs

- Auto accept escort/event confirm type quests - Implemented v0.2.04
  When someone in your group starts an escort quest, your toon can auto accept instead of having to click yes or miss out

- Auto Sell Gray/Junk - Implemented v0.2.00
  When a toon with the addon opens a vendor dialog, it will attempt to auto-sell gray quality items... need a blacklist to stop selling of arbitrary desired items

- Quest Log Count slash command - Implemented 10.0.4.000
 Wife got annoyed the default UI quest log doesn't give a count of quests active - so I added `/mtool qcount`

### SHELVED
- AutoTrade - SHELVED (AcceptTrade() can not be fired from addon due to WOW restrictions)
  IF a party member in your group with the addon AND in your white list clicks "accept trade", your toon will auto accept

- Triage - SHELVED: Not really useful outside multiboxing
  Auto switch party lead to next in line in your whitelist when current leader dies - ()

- LootSetter - SHELVED - just not sure this is relevant now
  Automatically set party loot to FFA when leader and party consists only of those on your ffa list. When adding members NOt on your list, switch to Group Loot

### IN PROGRESS
#### Whitelisting Improvements (varous states of completion)
- Treat "In my Guild" as whitelist override
  - See if you can get another Player's Guild from API to use to filter
- Treat "Is BattleNet Friend" as whitelist override
  - Treat "Is BattleNet Favorite" as Whitelist Override

### NOT STARTED
May move this to ToDo
- Inviter - Not Started

  Attempt to invite all those on your white list with one click

- "Follow Me" - Not Started

  Any toon in group with the addon can send a "follow me" command and the others will attempt to /follow them... this will probably ONLY work out of combat due to Blizz security

- Auto Quest Completion - Not Started

  Quests with simple turn-in-and-done dialogs will autocomplete when NPC dialog is opened

- Quest Progress Announcement - Not Started

  Announces to others in your party who have the addon when you make progress on a quest(like the old cosmos-based Party Quests) used to do

- Auto Share quests - Not Started

  when one toon picks up a quest, they will attempt to share with others in the group who have the addon

- Auto accept shared quests - Not Started

  when a shared quest is offered by another in your group with the addon, you will attempt to accept

- Auto restock reagents - Not Started

  When a toon with the addon opens vendor dialog, will scan for desired reagents/items as well as current supply in toon's inventory and buy enough to return to preset supply

- Group Hearth - Not Started

  Command to cause all in your group with MultiTool (in whitelist when I finally build that) to hearth (This may not be possible as it would require the addon to trigger a spell - not sure if allowed)

- Auto Deposit Warbank Funds

  With the new Warbank, it seems that auto dumping excess funds in might be nice

- Auto Deposit reagents to warband bank

Character banks have auto deposit reagents button by default, but the Warband banks auto button is just auto deposit Warbound items

I want a quick feature to let me deposit reagents in my warband bank

- Pet REminders (Hunter)
  - Dead Pet reminder
  - Dismissed Pet Reminder (Only when vehicle auto dismissed if posible)
  - Warn on Pet Dismissal if not done by Player casting?

When you're a beastmaster hunter your DPS sucks if your pet is dead... it can be so chaotic that its easy to miss till you say "why are my attacks not working / grayed out"

I've seen a few addons that do this - but most of them do way more and are a bit "spammy" for my linking

- BlackList (not sure if needed)

In my old guild sometimes friends would prank me knowing I had my auto accept summons on ... It was in fun so I never worried about it but it may be that someone is an abuser of this so a blacklist might be worthwhile but it's a lot of work so I may see if there's demand

- Dynamic Speed Indicator

  With Dragon Flying and vehicles my normal sanity check macro of "how fast am I moving" doesn't work. It thinks you're still. I like to know. It's especialy nice for dragonflying as you have an optimal glidepath for max speed / min descent rate

- In Combat Indicator
  I used to use X-Perl, then Z-Perl Unit frames, but changes in 12.x API have really had them struggling. I am TRYING to use the default UI but the one thing that bugs me is it's really nonobvious to me when I'm in combat from looking at my plate - i'd like something more ... visible

- Quest Sharing (via the quest log share quest API)
  - Auto Share Sharable Quests
  - AUto Accept Shared Quests

  Whether you're multiboxing (not really a think anymore) or just questing casually with a friend, it would be REALLY nice to just have a quick "share all sharable questst" 

  Likewise I'd like a accept offered quests automaticaly if I can...





## NOTES
There are probably many things I can't think of at the moment, but this is a good wish-list.

If I can figure out a way to do it, I may set this up as individual modules so that one can quickly enable/disable parts they want or don't want to save performance and to try and isolate the parts from each other as much as possible

```
---------------------------------------------------
|  TAXI DISPATCH...                               |
|      current setting: Shadowprey Village        |
| (you will automatically choose this destination)|
|   when you talk to a flightmaster)              |
|   ___                                           |
|  | X |   Uncheck this box to cancel your taxi   |
|   ---                                           |
---------------------------------------------------
```
