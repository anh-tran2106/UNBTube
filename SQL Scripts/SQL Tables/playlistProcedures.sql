-- --------------------getPlaylistCreator--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getPlaylistCreator //

CREATE PROCEDURE getPlaylistCreator(IN playlistIdIn int)
begin
  SELECT userId FROM playlist WHERE playlistId = playlistIdIn;
end//
DELIMITER ;

-- --------------------getPlaylistName--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getPlaylistName //

CREATE PROCEDURE getPlaylistName(IN playlistIdIn int)
begin
  SELECT name FROM playlist WHERE playlistId = playlistIdIn;
end//
DELIMITER ;

-- --------------------getPlaylistCreated--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getPlaylistCreated //

CREATE PROCEDURE getPlaylistCreated(IN playlistIdIn int)
begin
  SELECT created FROM playlist WHERE playlistId = playlistIdIn;
end//
DELIMITER ;

-- --------------------setPlaylistName--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS setPlaylistName //

CREATE PROCEDURE setPlaylistName(IN playlistIdIn int, nameIn varchar(256))
begin
  IF EXISTS(SELECT * FROM playlist WHERE playlistId = playlistIdIn)
    THEN UPDATE playlist SET name = nameIn WHERE playlistId = playlistIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'playlist does not exist';
  END IF;
end//
DELIMITER ;

-- ------------------------createPlaylist---------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS createPlaylist //

CREATE PROCEDURE createPlaylist(IN userIdIn int, nameIn varchar(256))
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn)
    THEN INSERT INTO playlist (userId, name, created) VALUES (userIdIn, nameIn, NOW());
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user does not exist';
  END IF;
end//
DELIMITER ;

-- ------------------------removePlaylist---------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removePlaylist //

CREATE PROCEDURE removePlaylist(IN playlistIdIn int)
begin
  IF EXISTS(SELECT * FROM playlist WHERE playlistId = playlistIdIn)
    THEN DELETE FROM playlist WHERE playlistId = playlistIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'playlist does not exist';
  END IF;
end//
DELIMITER ;