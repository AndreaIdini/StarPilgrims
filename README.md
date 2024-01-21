# Star Pilgrims

## Project description

This is the github repository for the project of the not-so-idle game "Star Pilgrims".
The README.md is still a jumbled mess of notes. Eventually, contribution is organised through t.me/scienza group.

## Game Mechanics

The main game mechanic is expanding and building through GUI, with an eye for realism in the quantities employed so no ridicolous exponential growth and upgrade popping up. It is quite "hardcore" with actions and decision that have consequences that can kill your playthrough and force you to start again. 
It takes some time to explore everything (latest playthrough took me 1h), but unfortunately there is no save mechanic as of yet.

It is slightly story driven, no spoilers here.

I appreciate any feedback and PR you will like to provide, even just to make order and refactoring.

## TODO

- Check the orbital dynamics and cost and the relation between number of engine, time of flight, and matter consumption
- Evaluate logarithmic curve for credits earning in factory in function of the number of humans, maybe difficult to balance. Evalaute a discount in credits for the cost of modules and other expenses after construction of factory.
- Implement Missions and Events so that can help or hinder.
- Make UI rescalable.

## Resources:

The following Creative Commons were used:

- Icons from https://game-icons.net/

## Notes

### Resources

- Energy, with Power and Energy battery capacity
- Matter
- Credits

Expansions cost Matter + Credits, Consume or produce Energy and Matter, maybe Credits.

Credits are earned through services (such as hosting people or computing).

Modules consume matter and energy.

### Costs:
	
- Solar Panel: 1KW = 10kg + 10k Credits
- Matter: 1kg = 1k Credits
- 1 Human: Gain: 20k Credits / day; Costs: 10kg/d; 100kWh/d = 4.1 kW
- Upkeep: X per module.

### Build:

Buiding takes time, but is reduced by log_2(number of humans+1). It needs a human to build things, and having more humans help but progressively less. 3 humans, the starting living quarter capacity, gives factor 2.

### Launch and orbits:

Launches of matter and humans need to be planned in advance, they have a cost in credits and a given capacity.

At a certain points it will be possible to change orbit, this will change the rate at which drones can accumulate matter but also cost and time needed for orbital launches, needing a more self-sufficient outpost but allowing for more resource accumulation.

Given the rocket equation
$$ \Delta V/v_e = \log (m_i/m_f),$$
where $\Delta V$ is the velocity difference, fundamental in rocket manouvering, $v_e$ is the velocity at exhaust is equal to the natural logarithm of the ratio between initial and final mass.
Given that for Asteroid Belt from LEO $\Delta V \approx 10 km/s$ (has to be doubled to slow down and give wiggle room) and $v_e$ for experimental ion thruster can be 100km/s, the ratio between initial and final mass is just e^{1/5}, so one needs 20% of the total mass of the object using the mentioned ion engine. In this condition the transfer time according to the paper is ~1 year or more, so additional velocity is very much needed.

### Events

## Sources

- **Mass/astronaut:** 7kg/day to eat and water per astronaut, water is reclaimed
https://ntrs.nasa.gov/api/citations/20190027563/downloads/20190027563.pdf
- **The thermal power to be dissipated** from the reactor would be about 1 MW. From the Stefan Boltzmann Law, the area of the radiator would be about 50 m2 and the mass approximately 500 kg. This seems quite reasonable.
https://nss.org/settlement/nasa/spaceresvol2/thermalmanagement.html
- **Battery** 400Wh/kg
- https://en.wikipedia.org/wiki/Electrical_system_of_the_International_Space_Station
- However, even this pales in comparison to Voyager 1, which was launched on Sept. 5th, 1977 and reached the Asteroid Belt on Dec. 10th, 1977 – a total of 96 days. And then there was the Voyager 2 probe, which launched 15 days after Voyager 1 (on Sept. 20th), but still managed to arrive on the same date – which works out to a total travel time of 81 days.
- https://www.sciencedirect.com/science/article/abs/pii/S0094576517311220. This examination of Main Belt asteroids as prospective targets for mining and exploration missions has found that within a delta-v of 8 km, starting from LEO, one can access 3986 MBAs
- https://descanso.jpl.nasa.gov/SciTechBook/series1/Goebel_02_Chap2_thruster.pdf Exhaust ion thrusters: 100 km/s.
- https://www.asterank.com/



