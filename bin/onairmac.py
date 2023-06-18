#!/usr/bin/python3
import subprocess
import re
import requests

def process_output(line):
    match = re.search(r'Cameras changed to \[(.*?)\]', line)
    if match:
        camera_name = match.group(1)
        print(f"{camera_name}")
        if camera_name == "":
            url = f'http://signpost.local/screen/?text=""'
        else:
            url = f'http://signpost.local/screen/?text=" ON AIR"'
        response = requests.get(url)
        if response.status_code != 200:
            print(f"Onair failed with status code: {response.status_code}")

def main():
    command = "log stream --predicate 'eventMessage contains \"Cameras changed to\"'"
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, universal_newlines=True)

    for line in process.stdout:
        line = line.strip()
        process_output(line)

    process.terminate()

if __name__ == "__main__":
    main()
