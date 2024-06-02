#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
SERVICES_MENU(){
 if [[ $1 ]]
  then
   echo -e "$1"
 fi
 services=$($PSQL "select * from services")
 echo "$services" | while IFS="|" read -r service_id name;
  do
    echo "${service_id}) ${name}"
  done
 read SERVICE_ID_SELECTED
 SERVICE_NAME=$($PSQL "select name from services where service_id = '$SERVICE_ID_SELECTED'")
 if [[ $SERVICE_ID_SELECTED =~ ^[1-5]$ ]];
  then
    echo "What's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_PHONE_RESULT=$($PSQL "select phone from customers where phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_PHONE_RESULT ]]
     then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_NAME_PHONE=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone ='$CUSTOMER_PHONE';")
      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
      read SERVICE_TIME
      INSERT_SERVICE_TIME=$($PSQL "insert into appointments(customer_id, service_id, time) values('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
     else
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone ='$CUSTOMER_PHONE';")
      CUSTOMER_NAME=$($PSQL "select name from customers where phone ='$CUSTOMER_PHONE';")
      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
      read SERVICE_TIME
      INSERT_SERVICE_TIME=$($PSQL "insert into appointments(customer_id, service_id, time) values('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  else
    SERVICES_MENU "\nI could not find that service. What would you like today?"
 fi
 }
SERVICES_MENU