"""Installer contract tests for autopoetic init (source → destination mapping)."""

from __future__ import annotations

import importlib.util
import subprocess
import sys
import textwrap
from pathlib import Path

import pytest
import yaml

PACKAGE_ROOT = Path(__file__).resolve().parents[1]
BIN = PACKAGE_ROOT / "bin" / "autopoetic"


def load_autopoetic():
    import importlib.machinery

    loader = importlib.machinery.SourceFileLoader("autopoetic_mod", str(BIN))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    sys.modules[loader.name] = mod
    loader.exec_module(mod)
    return mod


ap = load_autopoetic()


def write_manifest(path: Path, data: dict) -> Path:
    path.write_text(yaml.safe_dump(data, sort_keys=False), encoding="utf-8")
    return path


def sample_manifest() -> dict:
    return {
        "schema": "autopoetic-portable/v2",
        "openspec": {
            "invoke": "openspec init",
            "default_tools": ["cursor", "claude"],
            "default_profile": "core",
            "customize_opsx_templates": False,
        },
        "core": {
            "required": [
                {"source": "AGENTS.md", "destination": "AGENTS.md"},
                {
                    "source": "lambda-engine/CORE.md",
                    "destination": "lambda-engine/CORE.md",
                },
            ],
        },
        "cursor": {
            "claude_symlink": ".cursor",
            "rules": [
                {
                    "source": "src/rules/general/rule.mdc",
                    "destination": ".cursor/rules/general/rule.mdc",
                }
            ],
            "commands": [
                {
                    "source": "src/commands/halira.md",
                    "destination": ".cursor/commands/halira.md",
                }
            ],
            "skills": [
                {
                    "source": "src/skills/halira/",
                    "destination": ".cursor/skills/halira/",
                }
            ],
            "agents": [
                {
                    "source": "src/agents/halira-investigator.md",
                    "destination": ".cursor/agents/halira-investigator.md",
                }
            ],
        },
        "optional_bundles": {
            "code-explorer": {
                "description": "optional agent",
                "paths": [
                    {
                        "source": "src/agents/code-explorer.md",
                        "destination": ".cursor/agents/code-explorer.md",
                    }
                ],
            },
            "hooks": {
                "description": "hooks",
                "paths": [
                    {
                        "source": ".cursor/hooks.json",
                        "destination": ".cursor/hooks.json",
                    }
                ],
            },
        },
        "exclude": [
            "wiki/",
            "evals/",
            ".cursor/worktrees.json",
            ".cursor/.lambda-mode",
        ],
        "profiles": {
            "full": {
                "include": [
                    "core.required",
                    "cursor.rules",
                    "cursor.commands",
                    "cursor.skills",
                    "cursor.agents",
                ],
                "openspec": False,
                "claude_symlink": True,
            },
            "core-only": {
                "include": ["core.required"],
                "openspec": False,
                "claude_symlink": False,
            },
        },
    }


def seed_package(pkg: Path) -> None:
    (pkg / "lambda-engine").mkdir(parents=True)
    (pkg / "lambda-engine" / "CORE.md").write_text("# CORE\n", encoding="utf-8")
    (pkg / "AGENTS.md").write_text("# AGENTS\n", encoding="utf-8")
    (pkg / "src" / "rules" / "general").mkdir(parents=True)
    (pkg / "src" / "rules" / "general" / "rule.mdc").write_text(
        "rule\n", encoding="utf-8"
    )
    (pkg / "src" / "commands").mkdir(parents=True)
    (pkg / "src" / "commands" / "halira.md").write_text("cmd\n", encoding="utf-8")
    (pkg / "src" / "skills" / "halira").mkdir(parents=True)
    (pkg / "src" / "skills" / "halira" / "SKILL.md").write_text(
        "skill\n", encoding="utf-8"
    )
    (pkg / "src" / "agents").mkdir(parents=True)
    (pkg / "src" / "agents" / "halira-investigator.md").write_text(
        "agent\n", encoding="utf-8"
    )
    (pkg / "src" / "agents" / "code-explorer.md").write_text(
        "explorer\n", encoding="utf-8"
    )
    (pkg / ".cursor").mkdir(parents=True)
    (pkg / ".cursor" / "hooks.json").write_text("{}\n", encoding="utf-8")
    (pkg / ".cursor" / "worktrees.json").write_text("[]\n", encoding="utf-8")
    (pkg / "wiki").mkdir()
    (pkg / "wiki" / "secret.md").write_text("nope\n", encoding="utf-8")


@pytest.fixture
def pkg(tmp_path: Path):
    seed_package(tmp_path)
    write_manifest(tmp_path / "config.yaml", sample_manifest())
    return tmp_path


def test_load_manifest_rejects_v1(tmp_path: Path):
    path = write_manifest(tmp_path / "config.yaml", {"schema": "autopoetic-portable/v1"})
    with pytest.raises(SystemExit) as exc:
        ap.load_manifest(path)
    assert "autopoetic-portable/v2" in str(exc.value)


def test_parse_rejects_string_and_traversal():
    with pytest.raises(SystemExit):
        ap.parse_install_entry(".cursor/skills/", context="t")
    with pytest.raises(SystemExit):
        ap.parse_install_entry(
            {"source": "../etc/passwd", "destination": ".cursor/x"}, context="t"
        )
    with pytest.raises(SystemExit):
        ap.parse_install_entry(
            {"source": "/abs", "destination": ".cursor/x"}, context="t"
        )
    with pytest.raises(SystemExit):
        ap.parse_install_entry({"source": "a"}, context="t")


def test_profile_resolution_and_optional_bundle(pkg: Path):
    manifest = ap.load_manifest(pkg / "config.yaml")
    entries, profile = ap.resolve_profile_entries(manifest, "full", [])
    assert profile["claude_symlink"] is True
    dests = {e.destination for e in entries}
    assert "AGENTS.md" in dests
    assert ".cursor/skills/halira" in dests or ".cursor/skills/halira/" in {
        e.destination for e in entries
    }
    assert not any("code-explorer" in e.destination for e in entries)

    with_bundle, _ = ap.resolve_profile_entries(manifest, "full", ["code-explorer"])
    assert any(e.destination.endswith("code-explorer.md") for e in with_bundle)

    with pytest.raises(SystemExit):
        ap.resolve_profile_entries(manifest, "nope", [])
    with pytest.raises(SystemExit):
        ap.resolve_profile_entries(manifest, "full", ["missing-bundle"])


def test_excludes_source_and_destination():
    entry = ap.InstallEntry(
        source="src/skills/x", destination=".cursor/worktrees.json"
    )
    assert ap.entry_is_excluded(entry, [".cursor/worktrees.json"])
    entry2 = ap.InstallEntry(source="wiki/secret.md", destination="wiki/secret.md")
    assert ap.entry_is_excluded(entry2, ["wiki/"])


def test_validate_missing_sources(pkg: Path):
    entries = [
        ap.InstallEntry(source="missing.md", destination="missing.md"),
        ap.InstallEntry(source="AGENTS.md", destination="AGENTS.md"),
    ]
    with pytest.raises(SystemExit) as exc:
        ap.validate_sources(pkg, entries)
    assert "missing.md" in str(exc.value)


def test_dry_run_does_not_write(pkg: Path, tmp_path: Path):
    target = tmp_path / "out"
    target.mkdir()
    manifest = ap.load_manifest(pkg / "config.yaml")
    entries, _ = ap.resolve_profile_entries(manifest, "full", [])
    excludes = list(manifest.get("exclude") or [])
    filtered = [e for e in entries if not ap.entry_is_excluded(e, excludes)]
    for entry in filtered:
        status, label = ap.copy_entry(
            entry,
            package_root=pkg,
            target=target,
            dry_run=True,
            excludes=excludes,
        )
        assert status == "created"
        assert "src/" not in Path(label.split(" (from ")[0]).parts or label.startswith(
            ".cursor"
        )
    assert list(target.iterdir()) == []


def test_full_install_maps_src_to_cursor(pkg: Path, tmp_path: Path):
    target = tmp_path / "target"
    target.mkdir()
    manifest = ap.load_manifest(pkg / "config.yaml")
    entries, profile = ap.resolve_profile_entries(manifest, "full", [])
    excludes = list(manifest.get("exclude") or [])
    filtered = [e for e in entries if not ap.entry_is_excluded(e, excludes)]
    ap.validate_sources(pkg, filtered)
    for entry in filtered:
        status, label = ap.copy_entry(
            entry,
            package_root=pkg,
            target=target,
            dry_run=False,
            excludes=excludes,
        )
        assert status == "created"
        assert "src/" not in entry.destination
        assert "src/" not in label.split(" (from ")[0]

    assert (target / "AGENTS.md").is_file()
    assert (target / "lambda-engine" / "CORE.md").is_file()
    assert (target / ".cursor" / "rules" / "general" / "rule.mdc").is_file()
    assert (target / ".cursor" / "commands" / "halira.md").is_file()
    assert (target / ".cursor" / "skills" / "halira" / "SKILL.md").is_file()
    assert (target / ".cursor" / "agents" / "halira-investigator.md").is_file()
    assert not (target / "src").exists()
    assert not (target / ".cursor" / "agents" / "code-explorer.md").exists()
    assert not (target / "wiki").exists()

    status, _ = ap.ensure_claude_symlink(target, dry_run=False)
    assert status == "created"
    assert (target / ".claude").is_symlink()
    assert (target / ".claude").resolve() == (target / ".cursor").resolve()
    assert (target / ".claude" / "skills" / "halira" / "SKILL.md").is_file()


def test_core_only_skips_cursor_tree(pkg: Path, tmp_path: Path):
    target = tmp_path / "core"
    target.mkdir()
    manifest = ap.load_manifest(pkg / "config.yaml")
    entries, profile = ap.resolve_profile_entries(manifest, "core-only", [])
    assert profile.get("claude_symlink") is False
    excludes = list(manifest.get("exclude") or [])
    filtered = [e for e in entries if not ap.entry_is_excluded(e, excludes)]
    for entry in filtered:
        ap.copy_entry(
            entry,
            package_root=pkg,
            target=target,
            dry_run=False,
            excludes=excludes,
        )
    assert (target / "AGENTS.md").is_file()
    assert not (target / ".cursor").exists()


def test_child_exclusion_on_destination(pkg: Path, tmp_path: Path):
    """Directory copy skips children matching exclude on either side."""
    (pkg / "src" / "skills" / "halira" / "skip-me.md").write_text("x\n", encoding="utf-8")
    entry = ap.InstallEntry(
        source="src/skills/halira",
        destination=".cursor/skills/halira",
    )
    target = tmp_path / "t"
    target.mkdir()
    ap.copy_entry(
        entry,
        package_root=pkg,
        target=target,
        dry_run=False,
        excludes=[".cursor/skills/halira/skip-me.md"],
    )
    assert (target / ".cursor" / "skills" / "halira" / "SKILL.md").is_file()
    assert not (target / ".cursor" / "skills" / "halira" / "skip-me.md").exists()


def test_cli_smoke_src_not_in_destination(pkg: Path, tmp_path: Path, monkeypatch):
    """Command-level smoke: real package init with --profile lambda-only."""
    target = tmp_path / "cli-target"
    # Use the real package root (not synthetic pkg) so CLI loads real config.
    result = subprocess.run(
        [
            sys.executable,
            str(BIN),
            "init",
            str(target),
            "--profile",
            "lambda-only",
            "--include",
            "code-explorer",
        ],
        cwd=str(PACKAGE_ROOT),
        capture_output=True,
        text=True,
        check=False,
    )
    assert result.returncode == 0, result.stderr + result.stdout
    assert (target / ".cursor" / "skills" / "halira" / "SKILL.md").is_file()
    assert (target / ".cursor" / "agents" / "code-explorer.md").is_file()
    assert (target / ".claude").is_symlink()
    assert not (target / "src").exists()
    # No installed path should be under src/
    for path in target.rglob("*"):
        if path.is_file():
            rel = path.relative_to(target).as_posix()
            assert not rel.startswith("src/"), rel
