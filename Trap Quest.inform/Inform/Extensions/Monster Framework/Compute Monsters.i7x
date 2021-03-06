Compute Monsters by Monster Framework begins here.

[We only compute monsters in the region of the player, to reduce the lag in between turns.]
Definition: A monster (called M) is simulated:
	if M is interested, decide yes; [NPCs waiting above or below wander off and get bored]
	if the player is in the Dungeon:
		if M is in the Dungeon, decide yes;
		otherwise decide no;
	if the player is in the Woods:
		if M is in the Woods, decide yes;
		otherwise decide no;
	if the player is in the Hotel:
		if M is in the Hotel, decide yes;
		otherwise decide no;
	if the player is in WoodsBoss01:
		if M is vine boss, decide yes;
		otherwise decide no;
	if the player is in the Mansion:
		if M is in the Mansion, decide yes;
		otherwise decide no;
	if the player is in the School:
		if M is in the School, decide yes;
		otherwise decide no;
	decide no.

timedebug is a number that varies. timedebug is 0.

To compute monsters:
	now shocked-monsters is 0; [This is the variable that makes sure we don't spam the player with too much humiliation flavour if several monsters notice them at once]
	if timedebug is 1:
		say "Entering slowtest territory, press enter and start your stopwatch.";
		wait 10000 ms before continuing;
	repeat with M running through alive simulated monsters:
		if timedebug is 1, say "Computing [M].";
		if M is not seeked: [Monsters that already got a chance to chase the player get no further action.]
			check immobility;
			if M is moved, compute turn 3 of M; [Monsters that already moved don't move again.]
			otherwise compute turn 1 of M; [This is a full monster turn.]
	now shocked-monsters is 0;
	repeat with M running through alive dying monsters:
		finally destroy M.

To compute turn (N - a number) of (M - a monster):
	[If N is 1, this is a full action
	if N is 2, this is a passive action (no attacking or perception)
	if N is 3, this is a stationary passive action (only perception)]
	if M is friendly-fucking:
		if M is not grabbing the player and M is not penetrating a body part, now M is not friendly-fucking; [We need to make sure that NPCs have the friendly fucking flag removed after they've finished a session, and this is probably the most reliable way to do it, if a little messy.]
	if M is dying:
		finally destroy M;
	otherwise if the sleep of M is 0:[Monsters can't do anything if they are sleeping]
		now current-monster is M; [Some functions care about which monster is current-monster]
		if M is penetrating a body part, now M is in the location of the player; [Just in case there's a glitch where the player remains stuck but can't interact with the monster because somehow it's in a different room]
		let monster-engaged be 1;
		if M is uninterested, now monster-engaged is 0;
		if N is not 2, check perception of M; [When the player moves room, all monsters get a non-violent moving action with no perception round.]
		if M is interested and monster-engaged is 0, now N is 3; [The monster doesn't get an action if it detected the player in the perception round this turn.]
		if N < 3, compute action N of M.

[!<computeUniqueEarlyActionOfMonster>+

This function represents any action taken by a monster that either supersedes a normal movement/combat/sex action from a monster, or needs to happen before any other kind of action.

@param <Monster>:<M> The monster taking the action

+!]
To compute unique early action of (M - a monster):
	do nothing.

[!<computeUniqueFinalActionOfMonster>+

This function represents any action taken by a monster that should happen after movement/combat/sex actions.

@param <Monster>:<M> The monster taking the action

+!]
To compute unique final action of (M - a monster):
	do nothing.

To compute action (N - a number) of (M - a monster):
	[If N is 1, this is a full action
	if N is 2, this is a passive action (no attacking)]
	compute unique early action of M;
	if M is in the location of the player and M is not penetrating a body part and M is not grabbing the player and M is friendly and (M is interested or N is 1), check disapproval of M;
	if M is interested:
		if the scared of M > 0 and M is not penetrating a body part:
			compute fleeing of M;
			if a random number from 1 to 5 is 1 and M is not in the location of the player and M is not nearby:
				bore M for 100 seconds;
		otherwise if M is in the location of the player:
			if N is 1:
				[unless M is penetrating a body part or M is grabbing the player or M is unfriendly, check disapproval of M;]
				if M is penetrating a body part or M is grabbing the player or M is unfriendly:
					check attack of M;
				otherwise:
					compute friendly boredom of M; [Potentially make them bored]
					if M is interested, compute interaction of M; [If still interested, check if there's anything for them to do]
		otherwise:
			if M is unfriendly:
				check seeking N of M;
				check chase boredom of M;
			otherwise:
				compute friendly boredom of M; [Potentially make them bored]
				if M is interested:
					check seeking N of M;
	otherwise:
		if the boredom of M is 0 and (there is a worn clanking cowbell or the player is glued seductively), check seeking N of M;
		otherwise check motion of M;
	compute unique final action of M.

To check chase boredom of (M - a monster):
	if M is not in the location of the player and a random number from 1 to (15 + (30 * the number of worn catbells)) is 1:
		bore M for 0 seconds; [Every turn the monster (after seeking) is not in the location of the player, there's a 1 in 15 chance of them getting bored.]
		compute survival check of M.

To compute survival check of (M - a monster):
	if M is strangers:
		now M is survived;
		compute survival rewards.

To say BecomesBoredFlav of (M - a monster):
	say "[BigNameDesc of M] seems to get bored of following you around.".


Compute Monsters ends here.

