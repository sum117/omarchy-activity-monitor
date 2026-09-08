# Activity Monitor

A native Omarchy panel for CPU, memory, GPU, network, storage, and process activity.
This is [sum117's fork](https://github.com/sum117/omarchy-activity-monitor) of
[Kristoffer Haugland's Activity Monitor](https://github.com/stappmus/omarchy-activity-monitor),
built on Omarchy. The plugin ID is `sum117.activity-monitor`.

The upstream panel supplies hardware-aware CPU diagrams, resource graphs, compact
and detailed views, sortable process metrics, and configurable sampling. Its native
reader runs while the panel is open and stops when it closes.

## Improvements in this fork

- Header actions use consistent Nerd Font glyphs and center their painted bounds
  horizontally and vertically inside native Omarchy buttons.
- Search has a plain placeholder and debounces filtering while typing.
- Content scrolls within the available screen height; focused settings controls
  are brought into view. Local tooltips wrap and stay within the overlay.
- CPU diagram corners and storage bars respect the user's corner setting.
- Left-click selects a process. Termination is an explicit action with a
  confirmation that names the process and PID. Normal termination sends SIGTERM;
  force termination sends SIGKILL only when explicitly chosen. Neither UI action
  promotes the selection to a parent application or automatically escalates.
- Tests exercise header pointer and keyboard activation, glyph alignment, immutable
  process identity, cancellation, and action guards.

Theme colors, fonts, controls, and panel anchoring continue to come from Omarchy.

## Install

Requires Omarchy's Quickshell shell, Python 3, and a C++17 compiler and Make to
build the sampler. GPU details depend on the available drivers and kernel counters.

```bash
git clone https://github.com/sum117/omarchy-activity-monitor.git ~/.config/omarchy/plugins/sum117.activity-monitor
make -C ~/.config/omarchy/plugins/sum117.activity-monitor -B activity-sampler
```

Add `{ "id": "sum117.activity-monitor" }` to your preferred `bar.layout` section
in `~/.config/omarchy/shell.json`, preserving other entries, then run:

```bash
omarchy restart shell
```

The repository retains upstream's bundled sampler for plugin-manager compatibility.
The build command above rebuilds it from the included source on your machine.

## Migrate an existing installation

Save local edits and back up `~/.config/omarchy/shell.json` first. If the destination
does not already exist:

```bash
mv ~/.config/omarchy/plugins/stappmus.activity-monitor ~/.config/omarchy/plugins/sum117.activity-monitor
git -C ~/.config/omarchy/plugins/sum117.activity-monitor remote set-url origin https://github.com/sum117/omarchy-activity-monitor.git
git -C ~/.config/omarchy/plugins/sum117.activity-monitor pull --ff-only
make -C ~/.config/omarchy/plugins/sum117.activity-monitor -B activity-sampler
```

Replace the old ID with `sum117.activity-monitor` in your shell configuration and
custom summon commands. Keep the other properties on the bar entry: those hold
your sampling and display preferences. Restart the shell.

## Use

- Click the bar icon to open or close the panel. It opens at the clicked widget.
- `e` toggles details; Escape leaves settings or collapses details, then closes.
- `/` focuses process search; `j` / `k` move through processes. Click a column
  header to sort, or use `c` / `m` / `w` / `p` / `t` / `n` for CPU, memory,
  estimated power, PID, runtime, or name.
- Left-click a process to select it. Choose **Terminate** or **Force terminate**
  to open a confirmation. Right-click or `x` requests normal termination.
  Cancel is selected initially. These actions target only the selected process.
- `s` opens settings; `r` refreshes; `?` shows shortcuts. `d` / `v` cycle disks
  and storage volumes in detailed view, with Shift reversing direction.

Settings save with the bar layout. Process activity is kept in memory and is not
an archive of application usage.

## Resource reporting and safety

Memory usage uses Linux's available-memory accounting. GPU metrics show what the
driver exposes; a power-gated GPU clock can read `IDLE`. Estimated process watts
are a CPU-time share of measured package power, not per-process hardware readings
or wall power. They are sampled only in detailed view and can be disabled.

The reviewed source reads local system counters and contains no network upload
code or shell interpolation of process names. Process actions use argument arrays
and a helper that checks ownership, start time, protected processes, and pidfds.
These checks reduce the risk of signaling a recycled PID. Normal termination may
be ignored by an application; force termination can lose unsaved work.

The optional power helper uses a narrowly scoped passwordless sudo rule for one
root-owned RAPL reader command. It is **not required** for other metrics. The
existing package name, `/usr/lib/stappmus-activity-monitor` path, and sudoers filename
are retained for compatibility with upstream's separately installed helper; the
plugin rename does not install or modify system privileges.

To build and install that optional helper deliberately:

```bash
makepkg --cleanbuild --install
```

The helper also retains the upstream `APP_TERM` command-line mode, which can target
a same-name parent and escalate; this fork's UI does not call that mode.

## Update or remove

```bash
git -C ~/.config/omarchy/plugins/sum117.activity-monitor pull --ff-only
make -C ~/.config/omarchy/plugins/sum117.activity-monitor -B activity-sampler
omarchy restart shell
```

To stop using the plugin, remove its bar entry and any explicit registration from
`shell.json`, then restart the shell. The optional power-helper package can be
removed separately with `sudo pacman -Rns omarchy-activity-monitor-power-helper`.

## Development checks

```bash
make -B activity-sampler
./test/all.sh
python3 test/run-fork-ui.py
omarchy plugin validate .
git diff --check
```

The shell tests include live local-counter checks and disposable process fixtures;
they need access to `/proc` and `/sys`. The UI check uses an isolated offscreen
Quickshell and Omarchy's installed components. Live Wayland checks are also needed
for anchoring, clipping, and input behavior.

## Credits and license

Original plugin by **Kristoffer Haugland (stappmus)**, based on **Omarchy**.
Fork changes by **Joao Victor Weyne Parente Caliman (sum117)**.
See [ATTRIBUTIONS.md](ATTRIBUTIONS.md) and the [MIT License](LICENSE).
