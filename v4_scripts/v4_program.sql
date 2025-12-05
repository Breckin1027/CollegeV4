
DROP TRIGGER IF EXISTS campus_id_before_insert;
DROP TRIGGER IF EXISTS campus_id_before_update;
DROP TRIGGER IF EXISTS campus_id_after_insert;
DROP TRIGGER IF EXISTS campus_id_after_update;
DROP TRIGGER IF EXISTS campus_id_after_delete;

DELIMITER //

CREATE TRIGGER campus_id_before_insert
	BEFORE INSERT ON user
	FOR EACH ROW
BEGIN 
	DECLARE prefix_id   VARCHAR(255);
    DECLARE max_suffix  VARCHAR(255);
    
	SET prefix_id = CONCAT(LOWER(SUBSTRING(NEW.first_name, 1, 2)), LOWER(SUBSTRING(NEW.last_name, 1, 4)));
	
    SELECT MAX(CAST(SUBSTRING(campus_id, LENGTH(prefix_id)+1, 1) AS UNSIGNED))
    INTO max_suffix
    FROM user
    WHERE campus_id LIKE CONCAT(prefix_id, '%');
    
    SET NEW.campus_id = CONCAT(prefix_id, max_suffix+1);
    SET NEW.campus_email = CONCAT(prefix_id, max_suffix+1, "@wsc.edu");
    SET NEW.first_name = CONCAT(UPPER(LEFT(NEW.first_name,1)), LOWER(SUBSTRING(NEW.first_name,2)));
    SET NEW.last_name = CONCAT(UPPER(LEFT(NEW.last_name,1)), LOWER(SUBSTRING(NEW.last_name,2)));
    
    SET NEW.created = NOW();
    SET NEW.updated = NOW();
    
    SET NEW.created_userid = CURRENT_USER();
    SET NEW.updated_userid = CURRENT_USER();
    
END//


CREATE TRIGGER campus_id_before_update
	BEFORE UPDATE ON user
    FOR EACH ROW
BEGIN 
	DECLARE prefix_id   VARCHAR(255);
    DECLARE max_suffix  VARCHAR(255);
    
	SET prefix_id = CONCAT(LOWER(SUBSTRING(NEW.first_name, 1, 2)), LOWER(SUBSTRING(NEW.last_name, 1, 4)));
	
    SELECT MAX(CAST(SUBSTRING(campus_id, LENGTH(prefix_id)+1, 1) AS UNSIGNED))
    INTO max_suffix
    FROM user
    WHERE campus_id LIKE CONCAT(prefix_id, '%');
    
    SET NEW.campus_id = CONCAT(prefix_id, max_suffix+1);
    SET NEW.campus_email = CONCAT(prefix_id, max_suffix+1, "@wsc.edu");
	SET NEW.first_name = CONCAT(UPPER(LEFT(NEW.first_name,1)), LOWER(SUBSTRING(NEW.first_name,2)));
    SET NEW.last_name = CONCAT(UPPER(LEFT(NEW.last_name,1)), LOWER(SUBSTRING(NEW.last_name,2)));
    
    SET NEW.updated = NOW();
    SET NEW.updated_userid = CURRENT_USER();
    
END //


CREATE TRIGGER campus_id_after_insert
	AFTER INSERT ON user
    FOR EACH ROW
BEGIN
	INSERT INTO audit_campus_id (user_id, old_campus_id, new_campus_id, old_campus_email, new_campus_email, changed_by, changed_at)
    VALUES (user_id, NULL, campus_id, NULL, campus_email,USER(), NOW());
END //


CREATE TRIGGER campus_id_after_update
	AFTER UPDATE ON user
    FOR EACH ROW
BEGIN 
	INSERT INTO audit_campus_id (user_id, old_campus_id, new_campus_id, old_campus_email, new_campus_email, changed_by, changed_at)
    VALUES (user_id, campus_id, campus_id, campus_email, campus_email,USER(), NOW());
END //

CREATE TRIGGER campus_id_after_delete
	AFTER DELETE ON user
    FOR EACH ROW
BEGIN
	INSERT INTO audit_campus_id VALUES
    (user_id, old_campus_id, new_campus_id, old_campus_email, new_campus_email, 
    CURRENT_USER(), NOW());
END //

CREATE EVENT one_time_delete_audit_rows
ON SCHEDULE AT NOW() + INTERVAL 1 MONTH
DO BEGIN
  DELETE FROM audit_campus_id WHERE changed_at < NOW() - INTERVAL 1 MONTH LIMIT 100;
END//

DELIMITER ;