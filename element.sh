#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ $# -eq 0 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[+-]?[0-9]+$ ]]
  then
    NUMBER_SEARCH=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    if [[ -z $NUMBER_SEARCH ]]
    then
      echo I could not find that element in the database.
    else
      INFO=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name,type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
      echo "$INFO" | while read NUMBER BAR MASS BAR MELTING BAR BOILING BAR SYMBOL BAR NAME BAR TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done 
    fi
  else
  ELEMENT_SEARCH=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  if [[ -z $ELEMENT_SEARCH ]]
  then
    SYMBOL_SEARCH=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    if ! [[ -z $SYMBOL_SEARCH ]]
    then
    INFO=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name,type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
    echo "$INFO" | while read NUMBER BAR MASS BAR MELTING BAR BOILING BAR SYMBOL BAR NAME BAR TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
    else
      echo I could not find that element in the database.
    fi
  else
    INFO=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name,type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
    echo "$INFO" | while read NUMBER BAR MASS BAR MELTING BAR BOILING BAR SYMBOL BAR NAME BAR TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done 
  fi
  fi
fi