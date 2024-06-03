/*
Build Code for CSC370 Project
Updated on 2nd June
Leo Dong
*/

CREATE DATABASE 370PROJECT25A;

use 370PROJECT25A;

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient (PatientID int PRIMARY KEY
                    ,FirstName varchar(255)
                    ,LastName varchar(255)
                    ,PatientHealthAuthority varchar(255)
                    ,PatientPostalCode varchar(255)
                    ,PatientCity varchar(255)
);
LOAD DATA LOCAL INFILE 'C:/Users/leodo/Desktop/2024summer/csc370/Project/CSC370-project/_patient.csv'
    INTO TABLE Patient
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

DROP TABLE IF EXISTS Equipment;
CREATE TABLE Equipment (EquipmentID int PRIMARY KEY
                       ,EquipmentCat varchar(255)
                       ,EquipmentDescription varchar(255)
                       ,InstallationRate int
);
LOAD DATA LOCAL INFILE 'C:/Users/leodo/Desktop/2024summer/csc370/Project/CSC370-project/_equipment.csv'
    INTO TABLE Equipment
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

DROP TABLE IF EXISTS Referral;
CREATE TABLE Referral (ReferralCaseID int PRIMARY KEY
                      ,PatientID int
                      ,DateOfReferral date
                      ,ReferralHealthCareProfessional varchar(255)
                      ,ReferralHealthAuthority varchar(255)
                      ,ReferralHealthAuthorityHospitalSite varchar(255)
                      ,ReferralSource varchar(255)
                      ,LongTerm bool
                      ,Palliative bool
                      ,Priority varchar(255)
);
LOAD DATA LOCAL INFILE 'C:/Users/leodo/Desktop/2024summer/csc370/Project/CSC370-project/_referral.csv'
    INTO TABLE Referral
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

DROP TABLE IF EXISTS Rental;
CREATE TABLE Rental (RentalID int PRIMARY KEY
                    ,ReferralCaseID int
                    ,EquipmentID int
                    ,LengthOfRentalWeeks int
                    ,LengthOfRentalMonth int
                    ,RentalStatus varchar(255)
                    ,DeliveryDate date
                    ,ReturnDate date
                    ,ExtensionDueDate date
                    ,PaymentFrequency varchar(255)
                    ,IsInstallation bool
                    ,DeliveryZone int
                    ,OverdueActionTaken int
);
LOAD DATA LOCAL INFILE 'C:/Users/leodo/Desktop/2024summer/csc370/Project/CSC370-project/_rental.csv'
    INTO TABLE Rental
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

DROP TABLE IF EXISTS EquipmentRentalRate;
CREATE TABLE EquipmentRentalRate (RentalRateID int PRIMARY KEY
                                 ,EquipmentID int
                                 ,PaymentFrequency varchar(255)
                                 ,RentalRate FLOAT
);
LOAD DATA LOCAL INFILE 'C:/Users/leodo/Desktop/2024summer/csc370/Project/CSC370-project/_equipmentrentalrate.csv'
    INTO TABLE EquipmentRentalRate
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

DROP TABLE IF EXISTS DeliveryRate;
CREATE TABLE DeliveryRate (DeliveryFeeID int PRIMARY KEY
                       ,EquipmentID int
                       ,DeliveryZone int
                       ,DeliveryRate FLOAT
);
LOAD DATA LOCAL INFILE 'C:/Users/leodo/Desktop/2024summer/csc370/Project/CSC370-project/_deliveryrate.csv'
    INTO TABLE DeliveryRate
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;