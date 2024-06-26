import os
import csv
import re
import sys

# Function to convert time from m:s or h:mm:ss to seconds
def convert_time_to_seconds(time_str):
    parts = time_str.split(':')
    if len(parts) == 3:  # h:mm:ss
        return int(parts[0]) * 3600 + int(parts[1]) * 60 + float(parts[2])
    elif len(parts) == 2:  # m:ss
        return int(parts[0]) * 60 + float(parts[1])
    return float(time_str)

# Function to convert kB to GB
def kb_to_gb(kb):
    return kb / (1024 ** 2)

# Directory containing .out files
directory = sys.argv[1]

# CSV file output
csv_file = 'timing.csv'

# Header for the CSV file
header = ['Experiment', 'Performance', 'User Time (s)', 'Sys. Time (s)', 'Real Time (s)', 'Real Time (m:s)', 'Max Mem. (GB)', 'Max Mem. (kB)']

# Open the CSV file for writing
with open(csv_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(header)

    # Iterate over each .out file in the directory
    for filename in os.listdir(directory):
        if filename.endswith('.out'):
            experiment = filename.split('-')[0]
            performance = None
            user_time = None
            system_time = None
            real_time_raw = None
            real_time_seconds = None
            max_mem_kb = None
            max_mem_gb = None

            with open(os.path.join(directory, filename), 'r') as f:
                for line in f:
                    if "Entire Test Set results" in line:
                        performance = float(re.search(r"\d*\.\d+(e[-+]?\d+)?", line).group())
                    elif "User time (seconds)" in line:
                        user_time = float(re.search(r"\d*\.\d+", line).group())
                    elif "System time (seconds)" in line:
                        system_time = float(re.search(r"\d*\.\d+", line).group())
                    elif "Elapsed (wall clock) time" in line:
                        real_time_raw = re.search(r"(\d+:\d+:\d+|\d+:\d+\.\d+)", line).group()
                        real_time_seconds = convert_time_to_seconds(real_time_raw)
                    elif "Maximum resident set size (kbytes)" in line:
                        max_mem_kb = int(re.search(r"[-+]?\d*\.\d+|\d+", line).group())
                        max_mem_gb = kb_to_gb(max_mem_kb)

            # Write the extracted information to the CSV file
            writer.writerow([experiment, performance, user_time, system_time, real_time_seconds, real_time_raw, max_mem_gb, max_mem_kb])

