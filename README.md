# Godot 4 Game Engine Project

A GDScript-based 2D game project featuring dynamic game-over/respawn logic, modular minigame flows, and time-based object interactions.

##  Core Mechanics

* **Global Life & Game Over System (`GlobalScript`):**
  * Centralized tracker for `lives` and `coins`.
  * Context-aware death handling: triggers scene respawns via `Marker2D` nodes for platformer sections, and immediate Game Over screens for non-platformer minigames.
* **Killzone Management (`killzone.gd`):**
  * Uses explicit `@export` references for `Marker2D` node targets to avoid fragile `get_node()` path failures.
* **Coin Collection:**
  * Interactive `Area2D` pickup logic tied directly to the global economy.
* **Timed Minigame Flow (`dropper_minigame.gd`):**
  * State-driven, time-based event sequencing (UI timer updates -> exit flag activation -> coin drops).
