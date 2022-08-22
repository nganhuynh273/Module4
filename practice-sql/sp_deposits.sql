-- Gui tien 
DELIMITER //
DROP PROCEDURE IF EXISTS sp_deposits;
 CREATE PROCEDURE sp_deposits(
	IN customer_id BIGINT,
    IN transaction_amount DECIMAL(12,0),
    OUT message varchar(255)
    )
 	BEGIN
 		DECLARE count_id INT;
        
        DECLARE flag_rollback BOOL DEFAULT false;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET flag_rollback = true;
        
		SET count_id = (SELECT COUNT(*) FROM customers c WHERE c.id = customer_id);
		IF(count_id = 0) THEN
			SET message = 'USER ID NOT EXIST';
		ELSE IF (transaction_amount < 50000 OR transaction_amount > 1000000000) THEN
			SET message = 'Amount per deposit must be less than or equal to 50,000 and greater than or equal to 1,000,000,000';
			ELSE
				START TRANSACTION;
				UPDATE customers c
				SET c.balance = c.balance + transaction_amount
				WHERE c.id = customer_id;
				INSERT INTO deposits (customer_id, created_at, transaction_amount)
				VALUES (customer_id, NOW(), transaction_amount);
                
                IF flag_rollback THEN
					SET message = 'DEPOSIT FAILURE!';
                    ROLLBACK;
				ELSE
					SET message = 'SUCCESSFUL DEPOSIT!';
                    COMMIT;
				END IF;
		 END IF;
         END IF;
 	END;//
 DELIMITER ;
 
 

 
 