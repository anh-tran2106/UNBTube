-- --------------------getPlaylist--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getPlaylist //

CREATE PROCEDURE getPlaylist(IN playlistIdIn int)
begin
  SELECT * FROM playlistEntry WHERE playlistId = playlistIdIn;
end//
DELIMITER ;

-- --------------------addToPlaylist--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS addToPlaylist //

CREATE PROCEDURE addToPlaylist(IN playlistIdIn int, videoIdIn int)
begin
  IF(SELECT * FROM playlist WHERE playlistId = playlistIdIn)
    THEN INSERT INTO playlistEntry (playlistId, videoId) VALUES (playlistIdIn, videoIdIn);
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'playlist does not exist';    
  END IF;
end//
DELIMITER ;

-- --------------------removeFromPlaylist--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeFromPlaylist //

CREATE PROCEDURE removeFromPlaylist(IN playlistIdIn int, videoIdIn int)
begin
  IF(SELECT * FROM playlist WHERE playlistId = playlistIdIn)
    THEN IF(SELECT * FROM playlistEntry WHERE playlistId = playlistIdIn and videoId = videoIdIn)
      THEN DELETE FROM playlistEntry WHERE playlistId = playlistIdIn and videoId = videoIdIn;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video is not in playlist';  
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'playlist does not exist';    
  END IF;
end//
DELIMITER ;