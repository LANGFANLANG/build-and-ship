#!/usr/bin/env python3
import argparse
import json
import time
import urllib.error
import urllib.request


def main():
    parser = argparse.ArgumentParser(description="Wait for an HTTP endpoint.")
    parser.add_argument("url")
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--interval", type=float, default=2)
    args = parser.parse_args()

    deadline = time.time() + args.timeout
    last_error = None

    while time.time() < deadline:
        try:
            with urllib.request.urlopen(args.url, timeout=args.interval) as response:
                status = response.getcode()
                if 200 <= status < 500:
                    print(json.dumps({"status": "PASS", "url": args.url, "statusCode": status}, indent=2))
                    return 0
        except (urllib.error.URLError, TimeoutError, OSError) as exc:
            last_error = str(exc)
        time.sleep(args.interval)

    print(json.dumps({"status": "FAIL", "url": args.url, "error": last_error}, indent=2))
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
