"""
Make snapshot

{"Tasks": {"total": 440, "running": 1, "sleeping": 354, "stopped": 1, "zombie": 0},
"%CPU": {"user": 14.4, "system": 2.2, "idle": 82.7},
"KiB Mem": {"total": 16280636, "free": 335140, "used": 11621308},
"KiB Swap": {"total": 16280636, "free": 335140, "used": 11621308},
"Timestamp": 1624400255}
"""
import argparse
import psutil
import json
import time
import os


class monitor:
    def createSnapshot():
        total = 0
        running = 0
        sleeping = 0
        stopped = 0
        zombie = 0
        for proc in psutil.process_iter():
            total += 1
            if proc.status() == "running":
                running += 1
            elif proc.status() == "sleeping":
                sleeping += 1
            elif proc.status() == "stopped":
                stopped += 1
            elif proc.status() == "zombie":
                zombie += 1
        tasks = {"total": total,
                 "running": running,
                 "sleeping": sleeping,
                 "stopped": stopped,
                 "zombie": zombie}
        cpu = {"user": psutil.cpu_times_percent().user,
               "system": psutil.cpu_times_percent().system,
               "idle": psutil.cpu_times_percent().idle}
        memory = {"total": int(psutil.virtual_memory().total / 1024),
                  "free": int(psutil.virtual_memory().free / 1024),
                  "used": int(psutil.virtual_memory().used / 1024)}
        swap = {"total": int(psutil.swap_memory().total / 1024),
                "free": int(psutil.swap_memory().free / 1024),
                "used": int(psutil.swap_memory().used / 1024)}
        timestamp = int(time.time())
        sn = {"Tasks": tasks,
              "%CPU": cpu,
              "KiB Mem": memory,
              "KiB Swap": swap,
              "Timestamp": timestamp}
        return sn


def main():
    """Snapshot tool."""
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", help="Interval between snapshots in seconds", type=int, default=1)
    parser.add_argument("-f", help="Output file name", default="snapshot.json")
    parser.add_argument("-n", help="Quantity of snapshot to output", default=5)
    args = parser.parse_args()
    snapshot = monitor.createSnapshot()
    os.system('clear')
    open(args.f, "w").close()
    with open(args.f, "w") as file:
        for q in range(args.n):
            json.dump(snapshot, file)
            file.write("\n")
            time.sleep(args.i)
            print(snapshot, end="\r")


if __name__ == "__main__":
    main()