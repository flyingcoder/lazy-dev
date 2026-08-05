"""Console-script entry for optional `pip install .` / editable installs.

Preferred bootstrap remains ``./bin/autopoetic install`` from a checkout.
"""

from __future__ import annotations

import importlib.machinery
import importlib.util
import sys
from pathlib import Path


def _load_cli():
    bin_path = Path(__file__).resolve().parent / "bin" / "autopoetic"
    if not bin_path.is_file():
        raise SystemExit(
            f"error: CLI script not found: {bin_path}\n"
            "  Prefer `./bin/autopoetic install` from an autopoetic-agent checkout."
        )
    loader = importlib.machinery.SourceFileLoader("autopoetic_bin", str(bin_path))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    sys.modules[loader.name] = mod
    loader.exec_module(mod)
    return mod


def main(argv: list[str] | None = None) -> None:
    mod = _load_cli()
    raise SystemExit(mod.main(argv))


if __name__ == "__main__":
    main()
