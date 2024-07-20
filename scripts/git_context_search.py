#!/usr/bin/env python3
import argparse
import subprocess


def run_git_grep(search_term, repo_path='.'):
    cmd = ['git', '-C', repo_path, 'grep', '-n', search_term]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, text=True)
    return result.stdout.splitlines()


def check_subsequent_lines(file, start_line, exclude_term, repo_path='.', line_range=10):
    end_line = start_line + line_range
    cmd = ['git', '-C', repo_path, 'grep', '-n', exclude_term, file]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, text=True)
    for line in result.stdout.splitlines():
        match_file, match_line, _ = line.split(':', 2)
        match_line = int(match_line)
        if start_line < match_line <= end_line:
            return True
    return False


def main(search_term, exclude_term, repo_path, line_range):
    for line in run_git_grep(search_term, repo_path):
        file, line_number, _ = line.split(':', 2)
        line_number = int(line_number)

        if not check_subsequent_lines(file, line_number, exclude_term, repo_path, line_range):
            print(f"{file}:{line_number}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Search in Git repository with context")
    parser.add_argument("search_term", help="Term to search for")
    parser.add_argument("exclude_term", help="Term to exclude in the specified range of lines")
    parser.add_argument("--repo-path", default='.', help="Path to the Git repository")
    parser.add_argument("--line-range", type=int, default=10,
                        help="Number of lines to look forward after a match (default is 10)")
    args = parser.parse_args()
    main(args.search_term, args.exclude_term, args.repo_path, args.line_range)
