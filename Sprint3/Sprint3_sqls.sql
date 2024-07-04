use 370PROJECT25A;

DROP TABLE IF EXISTS UserInfo;
CREATE TABLE UserInfo (UserID int PRIMARY KEY
    ,FirstName varchar(255)
    ,LastName varchar(255)
);
LOAD DATA LOCAL INFILE './CSC370-project/UserInfo.csv'
    INTO TABLE UserInfo
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;
ALTER TABLE UserInfo
    ADD COLUMN UserName VARCHAR(255);
UPDATE UserInfo SET UserName = CONCAT(FirstName, LastName, UserID)
WHERE TRUE;


DROP TABLE IF EXISTS RoleDescription;
CREATE TABLE RoleDescription (RoleID int PRIMARY KEY
    ,Role varchar(255)
);
LOAD DATA LOCAL INFILE './CSC370-project/RoleDescription.csv'
    INTO TABLE RoleDescription
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;
CREATE INDEX idx_role ON RoleDescription(Role);

DROP TABLE IF EXISTS UserRole;
CREATE TABLE UserRole (UserID int
    ,Role varchar(255)
);
ALTER TABLE UserRole
    ADD FOREIGN KEY (Role) REFERENCES RoleDescription(Role);
LOAD DATA LOCAL INFILE './CSC370-project/UserRole.csv'
    INTO TABLE UserRole
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

#The design is that users here are divided to 2 groups, inside rental company and external users(mostly hospital users)
#privilage view table for devs
CREATE VIEW vw_role_dev AS
    SELECT DISTINCT FirstName
         ,LastName
         ,Role
FROM UserRole
JOIN UserInfo
ON UserInfo.UserID = UserRole.UserID
ORDER BY FirstName
       ,LastName
       ,Role;

#privilage view table for external users
CREATE VIEW vw_role_external AS
SELECT DISTINCT FirstName
              ,LastName
              ,Role
FROM UserRole
         JOIN UserInfo
              ON UserInfo.UserID = UserRole.UserID
WHERE Role NOT IN ('dev', 'management')
ORDER BY FirstName
       ,LastName
       ,Role;

#leo is a dev, tim is external user
CREATE USER 'leo'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'tim'@'localhost' IDENTIFIED BY 'password';

/*
start giving privileges.
just one example
ideally, i would give these privileges to all users in the file. through some shell script maybe.
*/
GRANT ALL PRIVILEGES
    ON vw_role_dev
    TO 'leo'@'localhost','tim'@'localhost'
   WITH GRANT OPTION;

GRANT ALL PRIVILEGES
    ON vw_role_external
    TO 'tim'@'localhost'
    WITH GRANT OPTION;

#just practice revoke.
REVOKE ALL PRIVILEGES
    ON vw_role_dev
    FROM 'tim'@'localhost';

#see who are the users
SELECT user, host FROM mysql.user;


/*
ACID,
Transaction & Atomicity
*/
#make an inventory column to the equipment table
ALTER TABLE equipment
ADD COLUMN count int;



#do a rental of 4 Wheeled Walker
START TRANSACTION;

SET @equipment = '4 Wheeled Walker'
    ,@PatientFirstName = 'GIZ'
    ,@PatientLastName = 'Client1'
    ,@referrer = 5
    ,@count = 1;

SELECT PatientID
FROM patientinfo
WHERE LastName = @PatientLastName
AND FirstName = @PatientFirstName
    INTO @PatientID;

SELECT max(ReferralCaseID)+1 INTO @ReferralCaseID
FROM refer;

SELECT EquipmentID
FROM equipment
WHERE EquipmentDescription = @equipment
INTO @EquipmentID;

#delete the amount from inventory
UPDATE equipment
SET count = count - @count
WHERE EquipmentDescription = @equipment;

#add the transaction to referral(simple version)
INSERT INTO refer (ReferralCaseID,PatientID,referrerID)
VALUES (@ReferralCaseID
     ,@PatientID
     ,@referrer);

#add the transaction to rental(simple version)
INSERT INTO rentalaction (ReferralCaseID,EquipmentID,UnitCount)
VALUES (@ReferralCaseID
        ,@EquipmentID
        ,@count);

SELECT min(count) INTO @LeastAmountCheck
FROM equipment;

IF (@LeastAmountCheck < 0) THEN
    COMMIT;
ELSE
    ROLLBACK;
END IF;
