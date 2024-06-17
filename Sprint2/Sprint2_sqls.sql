use 370PROJECT25A;

#Show only the patients who got 2 times of referral
SELECT patient.PatientID
     ,COUNT(DISTINCT referral.ReferralCaseID) AS 'referral count'
FROM patient
LEFT JOIN referral
ON (patient.PatientID = referral.PatientID)
GROUP BY patient.PatientID
HAVING COUNT(*) = 2;

#list of all equipments' delivery rate
SELECT DISTINCT EquipmentCat
              ,EquipmentDescription
              ,DeliveryRate
FROM equipment
LEFT JOIN deliveryrate
ON equipment.EquipmentID = DeliveryRate.EquipmentID
ORDER BY EquipmentCat
       ,EquipmentDescription;

SHOW CREATE TABLE equipment;


#see which professionals(ID) referred no.33 equipment.
SELECT refer.referrerID
FROM refer
         JOIN
     (
         SELECT *
         FROM rentalaction
         WHERE EquipmentID = 33
         order by ReferralCaseID
     ) As equip33
     ON (refer.ReferralCaseID = equip33.ReferralCaseID);
