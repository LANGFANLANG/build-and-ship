#!/usr/bin/env python3
import argparse
import json
import platform
import shutil
import socket
import subprocess
import sys


def command_version(name, args=None):
    args = args or ["--version"]
    path = shutil.which(name)
    if not path:
        return {"installed": False, "path": None, "version": None}

    try:
        result = subprocess.run(
            [path, *args],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            timeout=10,
            check=False,
        )
        first_line = result.stdout.splitlines()[0] if result.stdout.splitlines() else ""
    except Exception as exc:
        first_line = f"installed, version check failed: {exc}"

    return {"installed": True, "path": path, "version": first_line}


def port_available(port):
    for host in ("127.0.0.1", "localhost"):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(0.5)
            if sock.connect_ex((host, int(port))) == 0:
                return False
    return True


def main():
    parser = argparse.ArgumentParser(description="Detect build-and-ship environment.")
    parser.add_argument("--ports", default="", help="Comma-separated ports to check.")
    args = parser.parse_args()

    ports = [p.strip() for p in args.ports.split(",") if p.strip()]

    result = {
        "os": platform.platform(),
        "git": command_version("git"),
        "node": command_version("node"),
        "npm": command_version("npm"),
        "pnpm": command_version("pnpm"),
        "yarn": command_version("yarn"),
        "java": command_version("java", ["-version"]),
        "maven": command_version("mvn", ["-version"]),
        "gradle": command_version("gradle", ["-version"]),
        "python": command_version("python"),
        "python3": command_version("python3"),
        "current_python": {"installed": True, "path": sys.executable, "version": sys.version.split()[0]},
        "pip": command_version("pip"),
        "pip3": command_version("pip3"),
        "uv": command_version("uv"),
        "docker": command_version("docker"),
        "docker_compose": command_version("docker", ["compose", "version"]),
        "mysql": command_version("mysql", ["--version"]),
        "psql": command_version("psql", ["--version"]),
        "redis_cli": command_version("redis-cli", ["--version"]),
        "mongosh": command_version("mongosh", ["--version"]),
        "ports": {port: {"available": port_available(port)} for port in ports},
    }

    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
