#!/bin/bash

echo "Url;Nom;Membres;Agenda;Comptes-rendus;Contributions des personnalités auditionnées" > liste-groupes.csv

curl -s http://www2.assemblee-nationale.fr/instances/embed/39462/GE/alpha/legislature/15 |
  tr '\n' ' ' |
  sed 's/[ \t]\+/ /g' |
  sed 's/<a href="\|\s*<\/a>/\n/g' |
  grep instances |
  sed 's/"> /,"/' |
  sed 's|^|http://www2.assemblee-nationale.fr|' |
  while read line; do
    url=$(echo $line | sed 's/,.*//')
    id=$(echo $url | awk -F '/' '{print $6}')
    membres=$(curl -s http://www2.assemblee-nationale.fr/instances/alpha/$id/2020-06-11/ajax/1/legislature/15 | grep Tous | sed 's/.*: //'| sed 's/<.*//')
    res=$(curl -s $url | grep 'class="ajax"' | sed 's/<\/.*//' | sed 's/.*>//' | tr "\n" "," | sed 's/^Comptes/,Comptes/' | sed -r 's/(Agenda|Comptes rendus|Contributions des personnalités auditionnées)/1/g')
    echo "$line\",$membres,$res"
  done >> liste-groupes.csv
