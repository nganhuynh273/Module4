DROP VIEW IF EXISTS  vw_transfers;
CREATE VIEW vw_Transfers AS 
SELECT 
	trans.id,
    trans.fees,
    trans.fees_amount,
    trans.transaction_amount,
    trans.transfer_amount,
    trans.sender_id,
    send.full_name AS senderName,
	trans.recipient_id,
    rec.full_name AS recderName
FROM transfers trans 
JOIN customers send ON sen.id = trans.sender_id
JOIN customers rec ON rec.id = trans.recipient_id;
   