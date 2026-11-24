# Rocket Radar 0.5.0

- Threat: a percentage beside the shield on every enemy plate. Damage and healers in a group get a yellow shield before a mob turns to them (from 70% by default, blinking from 90%); tanks see their lead over the next player, and the shield turns orange when it drops below 20%. All three values can be changed in the Threat tab.
- Inside instances the game often keeps those numbers hidden. Then the shield appears only when the game itself says you have passed the tank's threat, in yellow and blinking, with the number the game writes; tanks see the shield without the lead.
- Works with party frames from other UI addons: when the game's party frames are replaced, the cooldown icons and the debuff box attach to the new frames instead.
- The icons keep clear of art drawn outside those frames, like a round portrait on the side.
- Fixed Lua errors that could appear while looking for those frames.
