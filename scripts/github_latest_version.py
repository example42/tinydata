#!/usr/bin/python3
import requests
import sys

# Get the repo name from the first argument
repo = sys.argv[1]

# Get the data file from the second argument
file = sys.argv[2]

# Get the latest release version from Github API
url = "https://github.com/" + repo + "/releases/latest"
r = requests.get(url)
version = r.url.split('/')[-1]

# Open the file in append mode
with open(file, "a") as f:
  # Append a new line character at the end of file
  f.write("\n")
  # Append the version name to the file
  f.write(version)
