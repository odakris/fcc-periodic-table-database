#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if there is an argument
if [[ $1 ]]
then
  
  # if argument
  if [[ $1 =~ ^[1-9]{1,3}$ ]]
  then
    # if arg is a element number
    GET_ELEMENT_INFO=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,type,symbol,name FROM properties FULL JOIN types USING(type_id) FULL JOIN elements USING(atomic_number) WHERE atomic_number=$1")
  elif [[ $1 =~ ^[A-Z][a-z]{1}?$ ]]
  then
    # elif arg is a element symbol
    GET_ELEMENT_INFO=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,type,symbol,name FROM properties FULL JOIN types USING(type_id) FULL JOIN elements USING(atomic_number) WHERE symbol='$1'")
  elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
  then
    # else arg is a element name
    GET_ELEMENT_INFO=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,type,symbol,name FROM properties FULL JOIN types USING(type_id) FULL JOIN elements USING(atomic_number) WHERE name='$1'")
  else
    echo "I could not find that element in the database."
  fi

  # check if element exist in database
  if [[ $GET_ELEMENT_INFO ]]
  then
    # print element info
    echo "$GET_ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE SYMBOL NAME
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

else
  # if no argument
  echo "Please provide an element as an argument."
fi