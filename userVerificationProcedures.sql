-- --------------------getEmailHash-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getEmailHash //

CREATE PROCEDURE getEmailHash(IN userIdIn int)
begin
  SELECT emailHash FROM userVerification WHERE userId = userIdIn;
end//
DELIMITER ;

-- --------------------getEmailCreation-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getEmailCreation //

CREATE PROCEDURE getEmailCreation(IN userIdIn int)
begin
  SELECT created FROM userVerification WHERE userId = userIdIn;
end//
DELIMITER ;

-- --------------------createEmail-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS createEmail //

CREATE PROCEDURE createEmail(IN userIdIn int, emailHashIn varchar(255))
begin
  INSERT INTO userVerification (userID, emailHash, created) VALUES
    (userIdIn, emailHashIn, NOW());
end//
DELIMITER ;

-- ---------------------removeEmail---------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeEmail //

CREATE PROCEDURE removeEmail(IN userIdIn int)
begin
  DELETE FROM userVerification WHERE userId = userIdIn;
end//
DELIMITER ;