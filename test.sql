SHOW DATABASES;

use 370PROJECT25A;

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient (PatientID int PRIMARY KEY
                    ,FirstName varchar(255) NOT NULL
                    ,LastName varchar(255) NOT NULL
                    ,PatientHealthAuthority varchar(255) NOT NULL
                    ,PatientPostalCode varchar(255) NOT NULL
                    ,PatientCity varchar(255) NOT NULL
);


SHOW TABLE STATUS ;


LOAD DATA LOCAL INFILE 'C:/Users/leodo/Desktop/2024summer/csc370/Project/CSC370-project/patient.csv'
    INTO TABLE Patient
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;
SHOW VARIABLES LIKE 'local_infile';

SELECT * FROM Patient LIMIT 5;
SELECT * FROM Equipment LIMIT 5;
SELECT * FROM Referral LIMIT 5;
SELECT * FROM Rental LIMIT 5;
SELECT * FROM EquipmentRentalRate LIMIT 5;
SELECT * FROM DeliveryRate LIMIT 5;
