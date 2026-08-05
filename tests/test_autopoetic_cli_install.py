"""Machine-level install / uninstall tests for the autopoetic CLI."""

from __future__ import annotations

import importlib.machinery
import importlib.util
import os
import shutil
import subprocess
import sys
from pathlib import Path

PACKAGE_ROOT = Path(__file__).resolve().parents[1]
BIN = PACKAGE_ROOT / "bin" / "autopoetic"


def load_autopoetic():
    loader = importlib.machinery.SourceFileLoader("autopoetic_install_mod", str(BIN))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    sys.modules[loader.name] = mod
    loader.exec_module(mod)
    return mod


ap = load_autopoetic()


def run_cli(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(BIN), *args],
        cwd=str(PACKAGE_ROOT),
        capture_output=True,
        text=True,
        check=False,
    )


def test_self_contained_install_then_init_dry_run(tmp_path: Path):
    prefix = tmp_path / "prefix"
    target = tmp_path / "target"
    target.mkdir()

    result = run_cli(["install", "--prefix", str(prefix)])
    assert result.returncode == 0, result.stderr + result.stdout
    launcher = prefix / "bin" / "autopoetic"
    share = prefix / "share" / "autopoetic"
    assert launcher.is_symlink() or launcher.is_file()
    assert (share / "config.yaml").is_file()
    assert "Launcher:" in result.stdout

    env = os.environ.copy()
    env["PATH"] = f"{prefix / 'bin'}{os.pathsep}{env.get('PATH', '')}"
    init = subprocess.run(
        ["autopoetic", "init", str(target), "--profile", "core-only", "--dry-run"],
        cwd=str(tmp_path),
        capture_output=True,
        text=True,
        check=False,
        env=env,
    )
    assert init.returncode == 0, init.stderr + init.stdout
    assert "dry-run" in init.stdout
    assert list(target.iterdir()) == []


def test_install_idempotent_and_uninstall(tmp_path: Path):
    prefix = tmp_path / "prefix"
    first = run_cli(["install", "--prefix", str(prefix)])
    assert first.returncode == 0, first.stderr + first.stdout
    second = run_cli(["install", "--prefix", str(prefix)])
    assert second.returncode == 0, second.stderr + second.stdout
    launcher = prefix / "bin" / "autopoetic"
    assert launcher.exists() or launcher.is_symlink()

    un = run_cli(["uninstall", "--prefix", str(prefix)])
    assert un.returncode == 0, un.stderr + un.stdout
    assert not launcher.exists() and not launcher.is_symlink()
    assert not (prefix / "share" / "autopoetic").exists()


def test_link_mode_missing_root_error(tmp_path: Path):
    prefix = tmp_path / "prefix"
    fake_root = tmp_path / "gone-checkout"
    fake_root.mkdir()
    (fake_root / "bin").mkdir()
    bin_dir, share_dir, launcher = ap.install_paths(prefix)
    bin_dir.mkdir(parents=True)
    ap.write_link_launcher(launcher, fake_root)
    ap.write_install_meta(
        share_dir,
        mode="link",
        prefix=prefix,
        package_root=fake_root,
        launcher=launcher,
    )
    shutil.rmtree(fake_root)

    result = subprocess.run(
        [sys.executable, str(launcher), "init", "--help"],
        capture_output=True,
        text=True,
        check=False,
    )
    assert result.returncode != 0
    combined = result.stderr + result.stdout
    assert "package root missing" in combined
    assert str(fake_root) in combined


def test_checkout_init_without_machine_install(tmp_path: Path):
    """Existing ./bin/autopoetic init path still works with no machine install."""
    target = tmp_path / "cli-target"
    result = run_cli(
        ["init", str(target), "--profile", "lambda-only"]
    )
    assert result.returncode == 0, result.stderr + result.stdout
    assert (target / ".cursor" / "skills" / "halira" / "SKILL.md").is_file()
    assert (target / ".cursor" / "commands" / "debug.md").is_file()
    assert (target / ".cursor" / "agents" / "code-explorer.md").is_file()
    assert (target / ".claude").is_symlink()
