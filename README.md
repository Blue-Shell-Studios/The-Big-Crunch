# The Big Crunch

Godot 4 top-down space action game inspired by *Feeding Frenzy*.

Current direction: the player gathers scrap by destroying asteroids (and eventually other ships), grows stronger, and progresses to larger vessels.

## Contributors
Mark Leonel T. Misola (Xenon5443)\
Kent Francis Genilo (TheAmazingTurtle & Genicis)

## Current Gameplay (Implemented)
- Pilot a small vessel in a large map with asteroid clusters, patrol sites, and planets.
- Destroy asteroids to spawn scrap.
- Hold collect to magnetize nearby scrap.
- Gain EXP from collected scrap.
- Upgrade through ship stages: `SMALL -> MEDIUM -> LARGE -> MASSIVE`.
- Fire projectiles with left click.
- View HP/EXP bars in HUD.
- Encounter NPC ships with task-based behavior:
  - Errand ships: scavenge, mine, transport.
  - Assault ships: patrol routes.
  - Battleships: station at patrol points.

## Controls
| Action | Input |
| --- | --- |
| Move | `W A S D` or arrow keys |
| Shoot | Left mouse button (`attack`) |
| Collect scrap | Hold right mouse button (`collect`) |

## Project Status
This project is **in progress** and not yet feature-complete.

### Known limitations right now
- Player progression is not yet finished.
- Only the small player vessel currently has complete behavior script wiring (combat/collector/stats).
- NPC ships currently focus on autonomous tasks; direct combat pressure/escalation against the player is still limited.
- No final win/lose loop, balancing pass, or full progression economy yet.

## Tech Notes
- Engine: Godot `4.6` (GL compatibility).
- Main scene: `core/main.tscn`.
- Autoload singletons: `SignalBus`, `TaskManager`.
- Web export files are committed under `export/web` and deployed with GitHub Pages workflow.

## Near-Term Roadmap
- Finish progression across all player ship stages (stats, weapons, behavior).
- Expand ship-vs-ship combat and threat escalation.
- Add clearer progression milestones and end goals.
- Tune economy and difficulty around scrap collection and combat.

## Game Resources
| Asset | Credits / Designer |
|---|---|
| Spaceships | [Deep-Fold Void Fleet Pack](https://foozlecc.itch.io/void-fleet-pack-1) |
| Planets | [Deep-Fold Pixel Planet Generator](https://deep-fold.itch.io/pixel-planet-generator) |
| Background | [Deep-Fold Space Background Generator](https://deep-fold.itch.io/space-background-generator) |
| Title screen refs | [Ansimuz Space Background](https://ansimuz.itch.io/space-background), [Pinterest Pixel Font Ref](https://es.pinterest.com/pin/292593307062789859/) |
