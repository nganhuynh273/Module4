-- Chuyen khoan
  DELIMITER //
  DROP PROCEDURE IF EXISTS sp_transfer;
 CREATE PROCEDURE sp_transfer(
	IN sender_id BIGINT,
    IN recipient_id BIGINT,
    IN transfer_amount DECIMAL(12,0),
    OUT message varchar(255)
    )
 	BEGIN
 		DECLARE balance_for_sender_id DECIMAL(12,0);
        DECLARE transaction_amount DECIMAL(12,0);
        DECLARE fees_amount DECIMAL(12,0);
        DECLARE count_sender_id INT;
        DECLARE count_recipient_id INT;
        
        DECLARE flag_rollback BOOL DEFAULT false;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET flag_rollback = true;
		
        
        
        SET fees_amount = transfer_amount * 0.1;
        SET transaction_amount = transfer_amount + fees_amount;
        SET count_sender_id = (SELECT COUNT(*) FROM customers c WHERE c.id = sender_id);
        SET count_recipient_id = (SELECT COUNT(*) FROM customers c WHERE c.id = recipient_id);
        SET balance_for_sender_id = (SELECT c.balance FROM customers c WHERE c.id = sender_id);
        IF(count_sender_id = 0 OR count_recipient_id = 0) THEN
			SET message = 'USER ID NOT EXIST!';
        ELSE IF(sender_id = recipient_id) THEN
				SET message = "The receiving account must be different from the remittance account!";
			ELSE IF(transaction_amount > balance_for_sender_id) THEN
					SET message = "The remaining amount is not enough to make this transaction!";
				ELSE IF (transfer_amount < 10000 OR transfer_amount > 5000000) THEN
						SET message = "Minimum amount for each transaction must be greater than or equal to 10,000 and less than or equal to 5,000,000";
					ELSE
					 	START TRANSACTION;
						UPDATE customers c
						SET c.balance = c.balance - transaction_amount
						WHERE c.id = sender_id;
						UPDATE customers c
						SET c.balance = c.balance + transfer_amount
						WHERE c.id = recipient_id;
						INSERT INTO transfers (created_at, fees, fees_amount, transaction_amount, transfer_amount, recipient_id, sender_id)
						VALUES (NOW(), 10, fees_amount, transaction_amount, transfer_amount, recipient_id, sender_id);
                  
   
                      IF flag_rollback THEN
						SET message = 'Transaction failed!';	
                            ROLLBACK;
						ELSE
							SET message = 'Successful transaction!';
                            COMMIT;
 						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
 	END;//
 DELIMITER ;