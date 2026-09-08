# Attributions

## Upstream plugin

[Kristoffer Haugland (stappmus)](https://github.com/stappmus) maintains the original
[Omarchy Activity Monitor](https://github.com/stappmus/omarchy-activity-monitor).
This fork retains his native sampler, system metrics and CPU-topology model,
resource graphs, sampling lifecycle, settings, process identity checks, signal
helper, and optional power-helper packaging, along with the existing tests.
The retained preview images show upstream's UI and CPU-layout examples.

## Omarchy

[Omarchy](https://github.com/basecamp/omarchy), by David Heinemeier Hansson and
contributors, supplies the original activity-panel foundation and installed shell
components used here, including panel anchoring, themes, buttons, typography,
and control states. Interface icons are Nerd Font glyphs rendered with the user's
configured font; they are not custom image assets from this fork.

## Fork contributions

[Joao Victor Weyne Parente Caliman (sum117)](https://github.com/sum117) maintains
[this fork](https://github.com/sum117/omarchy-activity-monitor). Contributions include
header glyph alignment and keyboard activation, constrained scrolling and tooltips,
plain debounced search, theme-aware corners, explicit process termination choices,
additional UI tests, plugin-ID migration, and documentation.

The fork is maintained independently of upstream. The plugin uses
`sum117.activity-monitor`; the optional system power helper retains its existing
package and filesystem names for compatibility.

All existing copyright notices are preserved in [LICENSE](LICENSE). Fork changes
use the same MIT license. Installed fonts and external dependencies retain their
own licenses.
