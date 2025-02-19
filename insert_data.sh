#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#instead of cat games.csv + if [[ $YEAR == "year" ]] below it to ignore the first line I can do tail -n +2 to skip the first line
tail -n +2 games.csv | while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  #insert into teams table
  #check to see if the winner team is already in the teams table
  WINNER_ID=$($PSQL "select team_id from teams where name = '$winner'")
  #WINNER_ID will be null if there's no entry with that name
  if [[ -z $WINNER_ID ]]
    then
    #inserts the new entry
    INSERT_WINNER_RESULT=$($PSQL "insert into teams (name) values ('$winner')")
    #check if insertion was successful
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo $winner was successfully inserted to the teams table
    fi
  fi
  #check to see if the loser team is already in the teams table. Rest is the same as for the winner
  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$opponent'")
  if [[ -z $OPPONENT_ID ]]
    then
    #inserts the new entry
    INSERT_OPPONENT_RESULT=$($PSQL "insert into teams (name) values ('$opponent')")
    #check if insertion was successful
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo $opponent was successfully inserted to the teams table
    fi
  fi
 #insert each row almost as is into the games table. Only need to insert team_id instead of team name
 WINNER_ID=$($PSQL "select team_id from teams where name = '$winner'")
 OPPONENT_ID=$($PSQL "select team_id from teams where name = '$opponent'")
 INSERT_GAME_RESULT=$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
 values ($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
     if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo $year $round was successfully inserted to the games table
    fi
done