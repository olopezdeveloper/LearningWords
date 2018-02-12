BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS `words` (
	`text`	TEXT,
	`img`	TEXT
);
INSERT INTO `words` VALUES ('chicken','chicken');
INSERT INTO `words` VALUES ('hen','hen');
INSERT INTO `words` VALUES ('pencil','pencil');
INSERT INTO `words` VALUES ('pen','pen');
INSERT INTO `words` VALUES ('squirrel','squirrel');
CREATE TABLE IF NOT EXISTS `records` (
	`level`	INTEGER,
	`date_time`	DATETIME,
	`siri_help`	INTEGER
);

COMMIT;
