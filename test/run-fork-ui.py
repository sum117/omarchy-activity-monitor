#!/usr/bin/env python3
"""Exercise actual QML pointer handlers in an isolated, offscreen Quickshell."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

repo = Path(__file__).resolve().parents[1]
shell = Path(os.environ.get('OMARCHY_PATH', '/usr/share/omarchy')) / 'shell'
with tempfile.TemporaryDirectory(prefix='activity-ui-') as temp:
    root = Path(temp)
    (root / 'runtime').mkdir(mode=0o700)
    for name in ['Commons', 'Ui']:
        (root / name).symlink_to(shell / name, target_is_directory=True)
    for name in ['HeaderAction.qml', 'BoundedToolTip.qml', 'ProcessActionController.qml', 'Model.js']:
        shutil.copy2(repo / name, root)
    shutil.copy2(repo / 'test/fork-ui.qml', root / 'shell.qml')
    env = dict(os.environ, XDG_RUNTIME_DIR=str(root / 'runtime'),
               QT_QPA_PLATFORM='offscreen', QT_QPA_PLATFORMTHEME='',
               QT_QUICK_CONTROLS_STYLE='Basic')
    env.pop('WAYLAND_DISPLAY', None)
    result = subprocess.run(['qs', '-p', str(root / 'shell.qml')], env=env,
                            capture_output=True, text=True, timeout=10)
    output = result.stdout + result.stderr
    if result.returncode or 'FORK_UI_PASS' not in output or 'FORK_UI_FAIL' in output:
        raise SystemExit(output)
    print('Passed: header pointer/keyboard input, explicit signals, immutable identity, cancellation and action guards')
