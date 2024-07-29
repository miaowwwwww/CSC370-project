use 370PROJECT25A;

#Process rental transaction
#For every referral case
# I expect to get referrer id, referral HA, patient id,
#   possibly several equipment id, equipment count.
SET @referrer_id = 102;
SET @referrer_HA_id = 14;
SET @patient_id = 137;

SET @equipment_id1 = 11;
SET @equipment_count1 = 2;
SET @equipment_id2 = 12;
SET @equipment_count2 = 1;

#suppose we already have a simple insert into refer.
#using the case id to start modifying rent

SET @CaseID =0;

SELECT @CaseID := ReferralCaseID
FROM refer
WHERE referrerID = @referrer_id
AND PatientID = @patient_id
AND SiteID = @referrer_HA_id;

INSERT INTO rentalaction(ReferralCaseID, EquipmentID, UnitCount)
VALUES (@CaseID, @equipment_id1, @equipment_count1);

# this trigger make the equipment storage update whenever a new rent is done.
# from the suggestion prof gave at the start of the course lol.
CREATE TRIGGER rent
    BEFORE INSERT ON rentalaction
    FOR EACH ROW
    BEGIN
        UPDATE equipment SET count = count - @equipment_count1
        WHERE EquipmentID = NEW.EquipmentID;
    end;

# as the inventory update part is in place, the needs of generating reports is fairly straight forward.
#for example daily inventory check
SELECT EquipmentCat, EquipmentDescription,count
FROM equipment

