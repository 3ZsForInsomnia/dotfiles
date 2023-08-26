# $1 = path to ics file to split
# $2 = calendar to import to using gcalcli
# $3 = optional output path

if [[ -z "$3" ]]; then
  split-ics.py "$1" 1000
  dir=$(basename -s '.ics' $1)
else
  split-ics.py "$1" 1000 "$3"
  dir=$3
fi

for file in ./$dir/*.ics; do
  gcalcli --nocache --calendar "$2" import "$file"
done
