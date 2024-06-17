use 370PROJECT25A;




SELECT COUNT(DISTINCT PatientID)
FROM patient;

#Show city patient count descending
SELECT PatientCity
     ,COUNT(DISTINCT PatientID) AS 'Patient Count'
FROM patient
GROUP BY PatientCity
ORDER BY `Patient Count` DESC;

#Show how many times of referral a patient got
SELECT patient.PatientID
     ,COUNT(DISTINCT referral.ReferralCaseID) AS 'referral count'
FROM patient
LEFT JOIN referral
ON (patient.PatientID = referral.PatientID)
GROUP BY patient.PatientID;

#Show how many items got processed per referral
SELECT DISTINCT referral.ReferralCaseID
     ,COUNT(DISTINCT RentalID) AS 'items got processed'
FROM referral
LEFT JOIN rental
ON rental.ReferralCaseID = referral.ReferralCaseID
GROUP BY referral.ReferralCaseID;

SELECT DISTINCT referral.ReferralCaseID
FROM referral;

#list of all equipments' rental rate
SELECT DISTINCT equipment.EquipmentCat
              ,EquipmentDescription
              ,PaymentFrequency
              ,RentalRate
FROM equipment
LEFT JOIN equipmentrentalrate
ON equipmentrentalrate.EquipmentID = equipment.EquipmentID
ORDER BY EquipmentCat
       ,EquipmentDescription
       ,RentalRate;

#list of all equipments' delivery rate
SELECT DISTINCT EquipmentCat
              ,EquipmentDescription
              ,DeliveryZone
              ,DeliveryRate
FROM equipment
LEFT JOIN deliveryrate
ON equipment.EquipmentID = DeliveryRate.EquipmentID
ORDER BY EquipmentCat
       ,EquipmentDescription
       ,DeliveryZone