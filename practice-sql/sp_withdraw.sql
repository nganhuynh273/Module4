--  Rut tien
 DELIMITER //
 DROP PROCEDURE IF EXISTS sp_withdraw;
 CREATE PROCEDURE sp_withdraw(
	IN customer_id BIGINT,
    IN transfer_amount DECIMAL(12,0),
    OUT message varchar(255)
    )
 	BEGIN
 		DECLARE balance_for_id DECIMAL(12,0);
		DECLARE count_id INT;
        DECLARE transaction_amount DECIMAL(12,0);
        
        DECLARE flag_rollback BOOL DEFAULT false;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET flag_rollback = true;
        
		SET transaction_amount = transfer_amount + transfer_amount * 0.1;
        SET balance_for_id = (SELECT c.balance FROM customers c where c.id = customer_id);
		SET count_id = (SELECT COUNT(*) FROM customers c where c.id = customer_id);
		IF(count_id = 0)
		THEN
			SET message = 'USER ID NOT EXIST!';
			ELSE IF (transfer_amount < 50000 or transfer_amount > 5000000)
			   THEN
				  SET message = 'Minimum amount for each withdrawal must be greater than or equal to 50,000 and less than or equal to 5,000,000';
			ELSE IF (transaction_amount > balance_for_id)
				THEN
				  SET message = 'The remaining amount is not enough to make this transaction!';
			ELSE
				START TRANSACTION;
				UPDATE customers c
				  SET c.balance = c.balance - transaction_amount
					 WHERE c.id = customer_id ;
					
				INSERT INTO withdraws(created_at, customer_id, transaction_amount)
				VALUES (NOW(), customer_id, transaction_amount);
                IF flag_rollback THEN
					SET message = 'Withdrawal failed!';
                    ROLLBACK;
				ELSE
					SET message = 'Withdrawal successful!';
                    COMMIT;
				END IF;
			END IF;
			END IF;
		END IF;
 	END;//
 DELIMITER ;