use 370PROJECT25A;

/*
logging see doc "logging"
*/

/*
Isolation levels example, 3 examples.
*/

#privilage view table for external users ----
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
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
COMMIT;


#Show city patient count descending
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT PatientCity
     ,COUNT(DISTINCT PatientID) AS 'Patient Count'
FROM patient
GROUP BY PatientCity
ORDER BY `Patient Count` DESC;
COMMIT;


#Show how many items got processed per referral
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
START TRANSACTION;
SELECT DISTINCT referral.ReferralCaseID
              ,COUNT(DISTINCT RentalID) AS 'items got processed'
FROM referral
         LEFT JOIN rental
                   ON rental.ReferralCaseID = referral.ReferralCaseID
GROUP BY referral.ReferralCaseID;
COMMIT;


/*
Subsets
*/
#subsets are used when some subsets have some unique attributes.
#in my case, this does not really apply to any of my attributes, so no subset needed.

/*
Qualities of a good conceptual design
*/

#Completeness: In the next sprint, this will be a part of the final project check.
#Correctness: My ERD looks to be correctly addressing the relations.
#Minimality: My schema is quite minimal with no parts can be deleted. For example, any field deleted could lead to missing infos.
#Expressiveness: as the primary goal of the project is to record rental info, my design goal is quite easy to recognize.
#Readability: I tweaked the ERD a bit to make it better for understanding.
#Self-Explanation: The ERD is pretty easy to understand. For example, referrers on referral sites refers patients to rent equipments.
#                  which could be delivered with some delivery rate.
#Extensibility: every aspect is mostly in its own place, adding requirements is not hard to achieve.
#Normality: It fits into BCNF, which is the most suitable NF in the 3 I learnt.

/*
improve relations with 3NF and/or 4NF
*/

#With examine for BCNF, 3NF and 4NF, BCNF is the relation that fits my need the most.
#So the relation will remain the same.

#If i use 3NF, I would leave too many entities connected to each other, which prevents extensibility.
# BCNF handles cases that 3NF might miss, resulting in a more robust and efficient database schema.

#BCNF effectively reduces redundancy by addressing functional dependencies without the added complexity of managing multi-valued dependencies found in 4NF.
# This makes BCNF more practical and easier to manage in this database design.










