-- -------------user table----------------
DROP TABLE IF EXISTS user;
CREATE TABLE user(
    userId int NOT NULL AUTO_INCREMENT,
    username varchar(256) NOT NULL, 
    email varchar(256) NOT NULL,
    pswd varchar(256) NOT NULL,
    salt varchar(256) NOT NULL,
    verified boolean NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (userId)
);

-- -------userVerification table----------
DROP TABLE IF EXISTS userVerification;
CREATE TABLE userVerification(
    userId int NOT NULL,
    emailHash varchar(256) NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);

-- ---------subscriber table-------------
-- subChannelId = Channel userId is subscribed to
-- userId = Channel that is subscribed to subChannelId
DROP TABLE IF EXISTS subscriber;
CREATE TABLE subscriber(
    subChannelId int NOT NULL,
    userId int NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (subChannelId, userId),
    FOREIGN KEY (subChannelId) REFERENCES user(userId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);

-- -------------video table--------------
DROP TABLE IF EXISTS video;
CREATE TABLE video(
    videoId int NOT NULL AUTO_INCREMENT,
    userId int NOT NULL,
    title varchar(256) NOT NULL,
    description varchar(1024) NOT NULL,
    likes int NOT NULL,
    views int NOT NULL,
    videoFile varchar(256) NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (videoId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);

-- -----------videoLike table------------
DROP TABLE IF EXISTS videoLike;
CREATE TABLE videoLike(
    userId int NOT NULL,
    videoId int NOT NULL,
    dislike boolean NOT NULL, -- 0 for like 1 for dislike
    PRIMARY KEY (userId, videoId),
    FOREIGN KEY (userId) REFERENCES user(userId),
    FOREIGN KEY (videoId) REFERENCES video(videoId)
);

-- -----------comment table--------------
DROP TABLE IF EXISTS comment;
CREATE TABLE comment(
    commentId int NOT NULL AUTO_INCREMENT,
    userId int NOT NULL,
    videoId int NOT NULL,
    parentCommentId int NOT NULL,
    comment varchar(1024) NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (commentId),
    FOREIGN KEY (userId) REFERENCES user(userId),
    FOREIGN KEY (videoId) REFERENCES video(videoId)
);

-- ---------commentLike table------------
DROP TABLE IF EXISTS commentLike;
CREATE TABLE commentLike(
    userId int NOT NULL,
    videoId int NOT NULL,
    dislike boolean NOT NULL, -- 0 for like 1 for dislike
    PRIMARY KEY (userId, videoId),
    FOREIGN KEY (userId) REFERENCES user(userId),
    FOREIGN KEY (videoId) REFERENCES video(videoId)
);

-- ----------playlist table--------------
DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist(
    playlistId int NOT NULL AUTO_INCREMENT,
    userId int NOT NULL,
    name varchar(256) NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (playlistId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);

-- ---------playlistEntry table----------
DROP TABLE IF EXISTS playlistEntry;
CREATE TABLE playlistEntry(
    playlistId int NOT NULL AUTO_INCREMENT,
    videoId int NOT NULL,
    PRIMARY KEY (playlistId),
    FOREIGN KEY (playlistId) REFERENCES playlist(playlistId),
    FOREIGN KEY (videoId) REFERENCES video(videoId)
);
