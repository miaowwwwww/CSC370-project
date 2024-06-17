
#referer - site table
SELECT DISTINCT ReferralHealthCareProfessional
              ,ReferralHealthAuthorityHospitalSite
FROM referral
GROUP BY referral.ReferralCaseID;

#site - HA, source table
SELECT DISTINCT ReferralHealthAuthorityHospitalSite
              ,ReferralHealthAuthority
              ,ReferralSource
FROM referral
GROUP BY referral.ReferralCaseID;

DROP TABLE IF EXISTS hasite;
CREATE TABLE DeliveryRate (DeliveryFeeID int PRIMARY KEY
    ,EquipmentID int
    ,DeliveryZone int
    ,DeliveryRate FLOAT
);

#site - HA, source table

CREATE TABLE HealthAuthoritySite AS
SELECT DISTINCT ReferralHealthAuthorityHospitalSite
              ,ReferralHealthAuthority
              ,ReferralSource
FROM referral
GROUP BY referral.ReferralCaseID
ORDER BY ReferralSource
       ,ReferralHealthAuthorityHospitalSite


