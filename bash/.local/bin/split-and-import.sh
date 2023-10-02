# $1 = path to ics file to split
# $2 = calendar in zip to use
# $3 = optional output path
# $4 = calendar to import to using gcalcli

base=$(basename -s '.zip' "$1")
unzip -o "$1" -d "$base"

if [[ -z "$3" ]]; then
  split-ics.py "./$base/$2.ics" 900
else
  split-ics.py "./$base/$2.ics" 900 "$3"
fi
