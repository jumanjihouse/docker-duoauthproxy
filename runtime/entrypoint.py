#!/usr/bin/env python
import os
import re
import sys

# default configuration values
write_config = False
config = {
    'main': {
        'log_stdout': 'true'
    }
}

# read environment variables
for key in os.environ.keys():
    m = re.match('^DUO__(\w+)__(\w+)$', key)

    if not m:
        continue

    write_config = True
    section = m.group(1).lower()
    option = m.group(2).lower()
    value = os.environ.get(key)

    if not config.get(section):
        config[section] = {}

    config[section][option] = value

# generate cfg file
if write_config:
    f = open('/etc/duoauthproxy/authproxy.cfg', 'w')
    for section in config.keys():
        f.write('[{0}]\n'.format(section))

        for option in config[section]:
            value = config[section][option]
            f.write('{0}={1}\n'.format(option, value))

        f.write('\n')

    f.close()

# pass control to docker command
os.execvp(sys.argv[1], sys.argv[1:])
