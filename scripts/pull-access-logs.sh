#!/bin/bash

# synchronize nginx access.log for each host to /path/to/medienhaus-monitoring-docker/logs/ &&
# create goaccess report for each host seperately … and a custom report for all hosts combined

hosts=("host" "names" "with" "your" "access" "logs")
where="/opt/medienhaus-monitoring-docker/data/goaccess/var/www/html"

for host in ${hosts[@]}; do
  rsync -e "ssh -i ~/.ssh/id_rsa" -av "$host:access.log"* "$where/logs/$host/"
  zcat -f "$where/logs/$host/access.log"* | docker run --rm -i -e LANG="$LANG" -e TZ="Europe/Berlin" allinurl/goaccess --agent-list --anonymize-ip --output html --log-format COMBINED --persist --restore - > "$where/$host.html"
done
