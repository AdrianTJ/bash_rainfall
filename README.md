# Tiny Rain Simulator

A lightweight Bash script that simulates a rain effect in your terminal, featuring smooth animations, color depth, and robust terminal handling.

## Versions

- **`rain_v1.sh`** — Falling rain with one-frame splashes (`v`) where drops hit the bottom row.
- **`rain_v2.sh`** — Everything in v1, plus puddles that gradually accumulate along the bottom row (`_` grows into `~` as more drops land).

## Key Features

- **Visual Depth:** Uses varying blue tones and a mix of characters (`.`, `,`, `:`, `i`, `|`) to create a more immersive effect.
- **Graceful Exit:** Cleans up the terminal, restores the cursor, and resets colors when you stop the script.
- **Dynamic Resizing:** Automatically adapts to terminal window resizing.
- **Minimal Flicker:** Uses efficient cursor positioning for a smoother experience.
- **Thunder Effect:** Optional lightning flashes for a stormier feel.

## Usage

```bash
./rain_v2.sh
```

To enable thunder (lightning flashes):

```bash
./rain_v2.sh --thunder
# OR
THUNDER=true ./rain_v2.sh
```

Press `Ctrl+C` to stop the simulation.

## Customization

Adjust these variables at the top of the script:

- `SPEED`: Seconds between frames (default `0.05`) — lower is faster rain.
- `DENSITY`: Frequency of raindrops (lower values = more rain).
- `COLOR_RAIN`: ANSI color code for the rain (e.g., green for a Matrix effect).
- `PUDDLE_FULL` (v2 only): Drops a column must collect before its puddle deepens from `_` to `~`.

## Tests

```bash
./run_tests.sh
```

Runs every `tests/test_*.sh` suite and reports an aggregate result.

## Requirements

Bash and `tput` (part of ncurses, included in most Linux/macOS distributions).
