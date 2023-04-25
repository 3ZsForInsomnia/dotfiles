import json
import os
import platform
import sys

from python_hosts import Hosts, HostsEntry

system = platform.system()
if system == "Windows":
    path = "C:\\Windows\\System32\\drivers\\etc\\hosts"
else:
    path = "/etc/hosts"

hosts = Hosts(path=path)
file = open(os.path.expanduser("~") + "/.config/site-block/site-block.json")
site_groups = json.load(file)
args = sys.argv[1:]
command = args[0]
site_group = args[1]
sites = site_groups[site_group]

if command == "add":
    for site in sites:
        new_entry = HostsEntry(entry_type="ipv4", address="127.0.0.1", names=[site])
        hosts.add([new_entry])
elif command == "remove":
    for site in sites:
        hosts.remove_all_matching(name=site)

hosts.write()
