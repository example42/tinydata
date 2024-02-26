import subprocess
import os

def get_git_base_dir():
    try:
        base_dir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
        return base_dir.decode('utf-8').strip()
    except subprocess.CalledProcessError:
        print("This directory is not a Git repository.")
        return None

def get_files_in_directory(directory):
    file_list = []
    for dirpath, dirnames, filenames in os.walk(directory):
        for filename in filenames:
            file_list.append(os.path.join(dirpath, filename))
    return file_list
