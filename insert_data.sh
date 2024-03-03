#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    # check if winner_team_name already exists
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

    # if not found
    if [[ -z $team_id ]]
    then
      # insert winner_team_name into teams table
      INSERT_team_name_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $INSERT_team_name_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $winner
      fi
    fi

    # check if opponent_team_name already exists
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    # if not found
    if [[ -z $team_id ]]
    then
      # insert opponent_team_name into teams table
      INSERT_team_name_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $INSERT_team_name_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $opponent
      fi
    fi 
    
    # get winner_id and opponent_id
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    # insert year, round, winner_id, opponent_id, winner_goals, opponent_goals into games table
    INSERT_games_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
      if [[ $INSERT_games_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $year, $round, $winner_id, $opponent_id, $winner_goals, $opponent_goals
      fi
  fi    
done



