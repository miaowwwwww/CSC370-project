/*
data fix
*/
UPDATE referral
SET ReferralHealthAuthority = 'VCH'
WHERE ReferralHealthAuthority = 'VCHA';

UPDATE referral
SET ReferralHealthAuthority = 'FHA'
WHERE ReferralHealthAuthorityHospitalSite = 'Burnaby Hospital';

UPDATE referral
SET ReferralHealthAuthorityHospitalSite = 'Robert and Lily Lee Community Health Centre'
WHERE ReferralHealthAuthorityHospitalSite = 'Robert and Lily Lee Community';

UPDATE referral
SET ReferralSource = 'Acute care'
WHERE ReferralHealthAuthorityHospitalSite LIKE '%Hospital%';

UPDATE referral
SET ReferralSource = 'Community Health Service'
WHERE ReferralHealthAuthorityHospitalSite NOT LIKE '%Hospital%';


/*
referral data

*/

#referrer - site table
DROP TABLE IF EXISTS referrer;
CREATE TABLE referrer AS
SELECT DISTINCT ReferralHealthCareProfessional
FROM referral
GROUP BY referral.ReferralCaseID;

ALTER TABLE referrer
    ADD COLUMN referrerID INT AUTO_INCREMENT PRIMARY KEY;

#add the referrer id to raw data
ALTER TABLE referral
    ADD COLUMN referrerID INT;


UPDATE referral
    JOIN referrer ON referral.ReferralHealthCareProfessional = referrer.ReferralHealthCareProfessional
SET referral.referrerID = referrer.referrerID
WHERE referral.ReferralHealthCareProfessional = referrer.ReferralHealthCareProfessional;


#site - HA, source table
DROP TABLE IF EXISTS HealthAuthoritySite;
CREATE TABLE HealthAuthoritySite AS
SELECT DISTINCT ReferralHealthAuthorityHospitalSite
              ,ReferralHealthAuthority
              ,ReferralSource
FROM referral
GROUP BY referral.ReferralCaseID;

ALTER TABLE HealthAuthoritySite
    ADD COLUMN SiteID INT AUTO_INCREMENT PRIMARY KEY;

#add the site id to raw data
ALTER TABLE referral
    ADD COLUMN SiteID INT;


UPDATE referral
    JOIN HealthAuthoritySite ON referral.ReferralHealthAuthorityHospitalSite = HealthAuthoritySite.ReferralHealthAuthorityHospitalSite
SET referral.SiteID = HealthAuthoritySite.SiteID
WHERE referral.ReferralHealthAuthorityHospitalSite = HealthAuthoritySite.ReferralHealthAuthorityHospitalSite;



#refer - HA, source table
DROP TABLE IF EXISTS Refer;
CREATE TABLE Refer AS
SELECT DISTINCT ReferralCaseID
              ,PatientID
              ,referrerID
              ,SiteID
              ,DateOfReferral
              ,LongTerm  AS IsLongTerm
              ,Palliative AS IsPalliative
              ,Priority
FROM referral
GROUP BY referral.ReferralCaseID
ORDER BY PatientID
       ,referrerID;

ALTER TABLE Refer
    ADD PRIMARY KEY (ReferralCaseID),
    ADD FOREIGN KEY (PatientID)
        REFERENCES PatientInfo(PatientID),
    ADD FOREIGN KEY (referrerID)
        REFERENCES referrer(referrerID),
    ADD FOREIGN KEY (SiteID)
        REFERENCES Healthauthoritysite(SiteID);


SHOW CREATE TABLE Refer;

/*
Patient data
*/

#patient
DROP TABLE IF EXISTS PatientInfo;
CREATE TABLE PatientInfo AS
SELECT DISTINCT PatientID
              ,FirstName
              ,LastName
              ,PatientPostalCode
FROM patient;

ALTER TABLE PatientInfo
    ADD PRIMARY KEY (PatientID);


#Patient PC
DROP TABLE IF EXISTS PatientPostalCode;
CREATE TABLE PatientPostalCode AS
SELECT DISTINCT PatientPostalCode
              ,PatientCity
              ,PatientHealthAuthority
FROM patient;

ALTER TABLE PatientPostalCode
    ADD PRIMARY KEY (PatientPostalCode);

/*
Equipment Data
*/

# no change

/*
equipment rental rate Data
*/

#payment frequency
DROP TABLE IF EXISTS PaymentFrequency;
CREATE TABLE PaymentFrequency AS
SELECT DISTINCT PaymentFrequency
FROM equipmentrentalrate;

ALTER TABLE PaymentFrequency
    ADD COLUMN PaymentFrequencyID INT AUTO_INCREMENT PRIMARY KEY;

#add the referrer id to raw data
ALTER TABLE equipmentrentalrate
    ADD COLUMN PaymentFrequencyID INT;

UPDATE equipmentrentalrate
    JOIN PaymentFrequency ON equipmentrentalrate.PaymentFrequency = PaymentFrequency.PaymentFrequency
SET equipmentrentalrate.PaymentFrequencyID = PaymentFrequency.PaymentFrequencyID
WHERE equipmentrentalrate.PaymentFrequency = PaymentFrequency.PaymentFrequency;



#Rental Rate
ALTER TABLE equipmentrentalrate
DROP COLUMN RentalRateID,
DROP COLUMN PaymentFrequency;

ALTER TABLE equipmentrentalrate
    ADD FOREIGN KEY (EquipmentID)
        REFERENCES equipment(EquipmentID),
    ADD FOREIGN KEY (PaymentFrequencyID)
        REFERENCES paymentfrequency(PaymentFrequencyID);

/*
delivery rate Data
*/

#delivery zone
DROP TABLE IF EXISTS DeliveryZone;
CREATE TABLE DeliveryZone AS
SELECT DISTINCT DeliveryZone
FROM deliveryrate;

ALTER TABLE DeliveryZone ADD COLUMN DeliveryZoneID INT AUTO_INCREMENT PRIMARY KEY;

#add the referrer id to raw data
ALTER TABLE Deliveryrate
    ADD COLUMN DeliveryZoneID INT;

UPDATE Deliveryrate
    JOIN DeliveryZone ON Deliveryrate.DeliveryZone = DeliveryZone.DeliveryZone
SET Deliveryrate.DeliveryZoneID = DeliveryZone.DeliveryZoneID
WHERE Deliveryrate.DeliveryZone = DeliveryZone.DeliveryZone;

ALTER TABLE deliveryrate
    ADD FOREIGN KEY (EquipmentID)
        REFERENCES equipment(EquipmentID),
    ADD FOREIGN KEY (DeliveryZoneID)
        REFERENCES DeliveryZone(DeliveryZoneID);


#Rental Rate
ALTER TABLE Deliveryrate
    DROP COLUMN DeliveryFeeID,
    DROP COLUMN DeliveryZone;

/*
rental data
*/
UPDATE rental
SET ExtensionDueDate = NULL
WHERE ExtensionDueDate = 0000-00-00;

DROP TABLE IF EXISTS RentalAction;
CREATE TABLE RentalAction AS
SELECT DISTINCT ReferralCaseID
              ,EquipmentID
              ,PaymentFrequency
              ,DeliveryZone
              ,DeliveryDate
              ,ReturnDate
              ,ExtensionDueDate
              ,OverdueActionTaken
              ,UnitCount
              ,LengthOfRentalMonth
              ,LengthOfRentalWeeks
              ,RentalStatus
              ,IsInstallation
FROM rental;

ALTER TABLE RentalAction
    ADD FOREIGN KEY (ReferralCaseID)
        REFERENCES refer(ReferralCaseID),
    ADD FOREIGN KEY (EquipmentID)
        REFERENCES equipment(EquipmentID);
