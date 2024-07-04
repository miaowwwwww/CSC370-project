#!/bin/bash

# MySQL credentials
DB_USER="root"
DB_PASSWORD="qazqaz"
DB_NAME="370Project"

# MySQL executable path
MYSQL_EXEC="C:/Program Files/MySQL/MySQL Server 8.0/bin/mysql"

# Check if MySQL executable exists
if [ ! -f "$MYSQL_EXEC" ]; then
  echo "MySQL executable not found at $MYSQL_EXEC. Please check the path."
  exit 1
fi

# Fetch usernames from the userinfo table
USERNAMES=$($MYSQL_EXEC -u $DB_USER -p$DB_PASSWORD -D $DB_NAME -se "SELECT UserName FROM userinfo")

if [ $? -ne 0 ]; then
  echo "Error fetching usernames from the database."
  exit 1
fi

# Loop through each username and create a user with privileges
for USERNAME in $USERNAMES; do
    PASSWORD="default_password"  # Set a default password or generate one
    CREATE_USER_SQL="CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD';"
    GRANT_PRIVILEGES_SQL="GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$USERNAME'@'localhost' WITH GRANT OPTION;"
    
    # Execute the SQL statements
    $MYSQL_EXEC -u $DB_USER -p$DB_PASSWORD -D $DB_NAME -e "$CREATE_USER_SQL"
    if [ $? -ne 0 ]; then
      echo "Error creating user $USERNAME."
      continue
    fi

    $MYSQL_EXEC -u $DB_USER -p$DB_PASSWORD -D $DB_NAME -e "$GRANT_PRIVILEGES_SQL"
    if [ $? -ne 0 ]; then
      echo "Error granting privileges to user $USERNAME."
      continue
    fi

    echo "User $USERNAME created and granted privileges successfully."
done

# Flush privileges to apply changes
$MYSQL_EXEC -u $DB_USER -p$DB_PASSWORD -D $DB_NAME -e "FLUSH PRIVILEGES;"
if [ $? -ne 0 ]; then
  echo "Error flushing privileges."
  exit 1
fi

echo "All users created and privileges granted successfully."
