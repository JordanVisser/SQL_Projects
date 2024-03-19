CREATE TABLE bitcoin (
    trans_date                  DATE,	
    price_usd                   NUMERIC(8,3),
    code_size                   INT,
    sent_by_address             INT, 
    transactions                INT,
    mining_profitability        NUMERIC(6,4),
    sent_in_usd                 BIGINT,
    transaction_fees            NUMERIC(6,4),
    median_transaction_fee      NUMERIC(7,5),
    confirmation_time           NUMERIC(5,3),
    market_cap                  BIGINT,
    transaction_value           INT,
    median_transaction_value    NUMERIC(8,4),
    tweets                      INT,
    google_trends               NUMERIC(6,3),
    fee_to_reward               NUMERIC(5,3),
    active_addresses            INT,
    top_100_cap                 NUMERIC(5,3)
);

COPY bitcoin
FROM 'Insert your directory here'
WITH (FORMAT CSV,HEADER);

SELECT trans_date, CAST(code_size AS DECIMAL(18,2)) / transactions AS difficulty FROM bitcoin;

SELECT trans_date, median_transaction_fee * transactions AS daily_cost FROM bitcoin
WHERE median_transaction_fee > 0.5;

SELECT trans_date, CAST(sent_in_usd AS DECIMAL(18, 5)) / transactions AS avg_transaction FROM bitcoin
WHERE transactions > 400000;

SELECT ROUND(AVG(price_usd),2) AS avg_price, CAST(SUM(transactions) AS MONEY) AS total_transactions FROM bitcoin;

SELECT MIN(market_cap) AS low_cap, MAX(market_cap) AS high_cap, ROUND(MIN(price_usd),2) AS low_price_usd, ROUND(MAX(price_usd),2) AS high_price_usd FROM bitcoin;

SELECT MIN(median_transaction_fee) AS lowest_fee, MAX(median_transaction_fee) AS highest_fee, ROUND(AVG(transaction_fees),5) AS avg_fee
FROM bitcoin
WHERE trans_date BETWEEN '2017-08-10' AND '2019-08-10';

SELECT AVG(transactions) AS avg_transactions, AVG(sent_by_address) AS avg_active_addresses FROM bitcoin
WHERE transactions > 350000;

SELECT ROUND(AVG(google_trends)) AS avg_google_trends, SUM(tweets) AS total_tweets FROM bitcoin;

SELECT ROUND(MIN(confirmation_time),3) AS min_confirmation_time, ROUND(MAX(confirmation_time),3) AS max_confirmation_time, ROUND(AVG(confirmation_time),3) AS avg_confirmation_time FROM bitcoin;

SELECT ROUND(AVG(price_usd),2) AS avg_price_usd, ROUND(AVG(mining_profitability),2) AS avg_mining_profitability, ROUND(AVG(transaction_fees),2) AS avg_transaction_fees FROM bitcoin
WHERE trans_date BETWEEN '2020-03-01' AND '2020-11-30';

