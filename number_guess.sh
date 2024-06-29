#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read username

is_username=$($PSQL "select username from users where username ='$username'";)
if [[ -z $is_username ]];
 then
  insert_username=$($PSQL "insert into users (username) values ('$username')";)
  echo "Welcome, $username! It looks like this is your first time here."
 else
  games_played=$($PSQL "select games_played from users where username ='$is_username'";)
  best_game=$($PSQL "select best_game from users where username ='$is_username'";)
  echo "Welcome back, $is_username! You have played $games_played games, and your best game took $best_game guesses."
fi

random=$(( (RANDOM % (1000 - 1 + 1)) + 1 ))
count=0
echo "Guess the secret number between 1 and 1000:"
while true;
 do
  read input
  count=$((count + 1))
  if ! [[ "$input" =~ ^[0-9]+$ ]];
   then
    echo "That is not an integer, guess again:"
  elif [[ $input -gt $random ]];
   then
    echo "It's lower than that, guess again:"
  elif [[ $input -lt $random ]];
   then
    echo "It's higher than that, guess again:"
  else
   echo "You guessed it in $count tries. The secret number was $random. Nice job!"
   games_played=$($PSQL "select games_played from users where username ='$username'";)
   games_played=$((games_played + 1))
   update_games_played=$($PSQL "update users set games_played='$games_played' where username ='$username'";)
   best_game=$($PSQL "select best_game from users where username ='$username'";)
   if [[ $best_game -gt $count ]];
   then
    update_best_game=$($PSQL "update users set best_game='$count' where username ='$username'";)
   fi
   exit 0
  fi
done
