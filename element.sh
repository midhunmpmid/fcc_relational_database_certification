#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]];
  then
    echo -e "Please provide an element as an argument."
   elif [[ $1 =~ ^[0-9]+$ ]];
    then
      atomic_number=$($PSQL "select atomic_number from properties where atomic_number='$1'";)
      if [[ -z $atomic_number ]];
       then
        echo "I could not find that element in the database."
          else
            name=$($PSQL "select name from elements where atomic_number='$atomic_number'";)
            type=$($PSQL "select types.type from types left join properties using (type_id) where atomic_number = $atomic_number;";)
            mass=$($PSQL "select atomic_mass from properties where atomic_number='$atomic_number'";)
            melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number='$atomic_number'";)
            boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number='$atomic_number'";)
            symbol=$($PSQL "select symbol from elements where atomic_number='$atomic_number'";)
            echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
      fi

   elif [[ $1 =~ [^0-9] ]];
    then
      atomic_number0=$($PSQL "select atomic_number from elements where name='$1'";)
      atomic_number1=$($PSQL "select atomic_number from elements where symbol='$1'";)
      if [[ -z $atomic_number0 ]];
        then
          if [[ -z $atomic_number1 ]];
            then
              echo "I could not find that element in the database."
              exit 0
          fi
      fi
    if [[ -z $atomic_number1 ]];
      then
        name=$($PSQL "select name from elements where atomic_number='$atomic_number0'";)
        type=$($PSQL "select types.type from types left join properties using (type_id) where atomic_number = $atomic_number0;";)
        mass=$($PSQL "select atomic_mass from properties where atomic_number='$atomic_number0'";)
        melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number='$atomic_number0'";)
        boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number='$atomic_number0'";)
        symbol=$($PSQL "select symbol from elements where atomic_number='$atomic_number0'";)
        echo "The element with atomic number $atomic_number0 is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    fi

    if [[ -z $atomic_number0 ]];
      then
        name=$($PSQL "select name from elements where atomic_number='$atomic_number1'";)
        type=$($PSQL "select types.type from types left join properties using (type_id) where atomic_number = $atomic_number1;";)
        mass=$($PSQL "select atomic_mass from properties where atomic_number='$atomic_number1'";)
        melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number='$atomic_number1'";)
        boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number='$atomic_number1'";)
        symbol=$($PSQL "select symbol from elements where atomic_number='$atomic_number1'";)
        echo "The element with atomic number $atomic_number1 is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    fi           
fi