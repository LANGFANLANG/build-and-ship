#!/usr/bin/env python3
import argparse
import json
from pathlib import Path


def exists(root, name):
    return (root / name).exists()


def main():
    parser = argparse.ArgumentParser(description="Detect build-and-ship project shape.")
    parser.add_argument("--path", default=".", help="Project root to inspect.")
    args = parser.parse_args()

    root = Path(args.path).resolve()

    result = {
        "root": str(root),
        "git": exists(root, ".git"),
        "node": exists(root, "package.json"),
        "pnpm": exists(root, "pnpm-lock.yaml"),
        "yarn": exists(root, "yarn.lock"),
        "maven": exists(root, "pom.xml"),
        "gradle": exists(root, "build.gradle") or exists(root, "build.gradle.kts"),
        "python": exists(root, "requirements.txt") or exists(root, "pyproject.toml"),
        "docker": exists(root, "Dockerfile") or exists(root, "compose.yaml") or exists(root, "docker-compose.yml"),
        "envExample": exists(root, ".env.example"),
        "sourceDirs": [name for name in ["src", "test", "tests"] if exists(root, name)],
    }

    package_json = root / "package.json"
    if package_json.exists():
        try:
            package_text = package_json.read_text(encoding="utf-8")
            package = json.loads(package_text)
            deps = {}
            deps.update(package.get("dependencies") or {})
            deps.update(package.get("devDependencies") or {})
            result["frontend"] = {
                "vue": "vue" in deps,
                "react": "react" in deps,
                "vite": "vite" in deps,
            }
        except Exception as exc:
            result["packageJsonParseError"] = str(exc)

    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
