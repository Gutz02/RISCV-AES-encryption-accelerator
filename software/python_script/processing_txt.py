import re
import sys
import argparse
from pathlib import Path

def parse_args():
    parser = argparse.ArgumentParser(
        description="Extract LLVM analysis passes that were run but not invalidated."
    )
    parser.add_argument(
        "files",
        metavar="FILE",
        nargs="+",
        help="One or more LLVM pass-log text files to process"
    )
    return parser.parse_args()

def extract_non_invalidated(filename):
    running_re = re.compile(r"^\s*Running analysis:\s*([A-Za-z0-9_<>:]+)\s+on\b")
    invalidating_re = re.compile(r"^\s*Invalidating analysis:\s*([A-Za-z0-9_<>:]+)\s+on\b")

    ran_analyses = set()
    invalidated_analyses = set()

    try:
        with open(filename, "r", encoding="utf-8") as f:
            for line in f:
                # Check for "Running analysis: ..."
                m_run = running_re.match(line)
                if m_run:
                    pass_name = m_run.group(1)
                    ran_analyses.add(pass_name)
                    continue

                # Check for "Invalidating analysis: ..."
                m_inv = invalidating_re.match(line)
                if m_inv:
                    pass_name = m_inv.group(1)
                    invalidated_analyses.add(pass_name)
    except FileNotFoundError:
        print(f"Error: File not found: {filename}", file=sys.stderr)
        return None
    except IOError as e:
        print(f"I/O error({e.errno}): {e.strerror}", file=sys.stderr)
        return None

    # Analyses that ran but were never invalidated
    non_invalidated = ran_analyses - invalidated_analyses
    return non_invalidated

def main():
    args = parse_args()

    for filepath in args.files:
        path = Path(filepath)
        if not path.is_file():
            print(f"Warning: Skipping non-file: {filepath}", file=sys.stderr)
            continue

        result = extract_non_invalidated(filepath)
        if result is None:
            continue

        print(f"\nFile: {filepath}")
        if not result:
            print("  (No analysis passes remained after invalidation.)")
        else:
            print("  Analysis passes run and not invalidated:")
            for name in sorted(result):
                print(f"    - {name}")

if __name__ == "__main__":
    main()