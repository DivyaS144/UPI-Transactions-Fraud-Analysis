CREATE DATABASE upi_fraud_analysis;   -- creating a databse

USE upi_fraud_analysis; 


-- Creating tables:
-- 1. Customer Master
CREATE TABLE customer_master (
    customer_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    age INT CHECK (age >= 18),
    gender VARCHAR(10),
    region VARCHAR(50),
    date_joined DATE NOT NULL,
    is_business_user VARCHAR(5) CHECK (is_business_user IN ('True', 'False')),
    risk_score DECIMAL(4,2) CHECK (risk_score BETWEEN 0 AND 1)
);


-- 2. Device Info
CREATE TABLE device_info (
    device_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20),
    device_type VARCHAR(20),
    app_version VARCHAR(10),
    is_rooted VARCHAR(5) CHECK (is_rooted IN ('True', 'False')),
    last_active TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer_master(customer_id)
);


-- 3. Merchant Info
CREATE TABLE merchant_info (
    merchant_id     VARCHAR(20)     PRIMARY KEY,
    merchant_name   VARCHAR(150)    NOT NULL,
    merchant_type   VARCHAR(20)     NOT NULL CHECK (merchant_type IN ('grocery','food','online','apparel','electronics','transport')),
    region          VARCHAR(20)     NOT NULL CHECK (region IN ('north','south','east','west','central')),
    onboard_date    DATE            NOT NULL,
    risk_score      DECIMAL(4,2)    NOT NULL CHECK (risk_score BETWEEN 0 AND 1)
);


-- 4. Upi account Details
CREATE TABLE upi_account_details (
    upi_id          VARCHAR(60)     PRIMARY KEY,
    customer_id     VARCHAR(20)     NOT NULL,
    bank_name       VARCHAR(20)     NOT NULL CHECK (bank_name IN ('sbi','hdfc','icici','axis','kotak','pnb')),
    account_type    VARCHAR(25)     NOT NULL CHECK (account_type IN ('savings','current','credit_card_linked')),
    date_added      DATE            NOT NULL,
    status          VARCHAR(15)     NOT NULL CHECK (status IN ('active','blocked','suspended')),
    FOREIGN KEY (customer_id) REFERENCES customer_master(customer_id)
);


-- 5. Customer Feedback Surveys
CREATE TABLE customer_feedback_surveys (
    feedback_id         VARCHAR(20)     PRIMARY KEY,
    customer_id         VARCHAR(20)     NOT NULL,
    date_submitted      DATE            NOT NULL,
    feedback_text       TEXT            NOT NULL,
    satisfaction_score  TINYINT         NOT NULL CHECK (satisfaction_score BETWEEN 1 AND 5),
    issue_type          VARCHAR(20)     NOT NULL CHECK (issue_type IN ('fraud','transaction','app_usability','other')),
    resolved            VARCHAR(5)      NOT NULL CHECK (resolved IN ('True','False')),
    FOREIGN KEY (customer_id) REFERENCES customer_master(customer_id)
);


-- 6. UPI Transaction History
CREATE TABLE upi_transaction_history (
    transaction_id      VARCHAR(30)     PRIMARY KEY,
    upi_id              VARCHAR(60)     NOT NULL,
    customer_id         VARCHAR(20)     NOT NULL,
    timestamp           TIMESTAMP       NOT NULL,
    amount              DECIMAL(10,2)   NOT NULL CHECK (amount > 0),
    transaction_type    VARCHAR(20)     NOT NULL CHECK (transaction_type IN ('send','receive','merchant_payment','bill_pay')),
    merchant_id         VARCHAR(20)     NULL,
    counterparty_upi    VARCHAR(60)     NOT NULL,
    status              VARCHAR(10)     NOT NULL CHECK (status IN ('success','failed','pending')),
    device_id           VARCHAR(30)     NOT NULL,
    device_type         VARCHAR(20)     NOT NULL,
    channel             VARCHAR(15)     NOT NULL CHECK (channel IN ('app','qr_code','intent')),
    fraud_flag          VARCHAR(5)      NOT NULL CHECK (fraud_flag IN ('True','False')),
    reversal_flag       VARCHAR(5)      NOT NULL CHECK (reversal_flag IN ('True','False')),
    failure_reason      TEXT            NULL,
    FOREIGN KEY (customer_id)  REFERENCES customer_master(customer_id),
    FOREIGN KEY (upi_id)       REFERENCES upi_account_details(upi_id),
    FOREIGN KEY (merchant_id)  REFERENCES merchant_info(merchant_id)
);



-- Fraud Alert History
CREATE TABLE fraud_alert_history (
    alert_id            VARCHAR(20)     PRIMARY KEY,
    transaction_id      VARCHAR(30)     NOT NULL,
    alert_type          VARCHAR(25)     NOT NULL CHECK (alert_type IN ('frequent_failure','unusual_amount','unusual_time','suspicious_login')),
    alert_date          TIMESTAMP       NOT NULL,
    resolved            VARCHAR(5)      NOT NULL CHECK (resolved IN ('True','False')),
    resolution_date     TIMESTAMP       NULL,
    remarks             TEXT            NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES upi_transaction_history(transaction_id)
);






-- ============================================================
-- STEP 4 VALIDATION: Post-Ingestion Checks
-- ============================================================

-- ────────────────────────────────────────
-- 1. ROW COUNT CHECK
-- Expected: 10000 / 500 / 12000 / 12000 / 100000 / 4000 / 2000
-- ────────────────────────────────────────
SELECT 'customer_master'           AS tbl, COUNT(*) AS row_count FROM customer_master
UNION ALL
SELECT 'merchant_info',                    COUNT(*)         FROM merchant_info
UNION ALL
SELECT 'device_info',                      COUNT(*)         FROM device_info
UNION ALL
SELECT 'upi_account_details',              COUNT(*)         FROM upi_account_details
UNION ALL
SELECT 'upi_transaction_history',          COUNT(*)         FROM upi_transaction_history
UNION ALL
SELECT 'customer_feedback_surveys',        COUNT(*)         FROM customer_feedback_surveys
UNION ALL
SELECT 'fraud_alert_history',              COUNT(*)         FROM fraud_alert_history;


-- ────────────────────────────────────────
-- 2. FK INTEGRITY CHECKS
-- Expectation: both queries should return 0
-- ────────────────────────────────────────

-- Check: transactions referencing a customer_id that doesn't exist in customer_master
SELECT COUNT(*) AS orphan_txns
FROM upi_transaction_history t
LEFT JOIN customer_master c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Check: fraud alerts referencing a transaction_id that doesn't exist in upi_transaction_history
SELECT COUNT(*) AS orphan_alerts
FROM fraud_alert_history f
LEFT JOIN upi_transaction_history t ON f.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;


-- ────────────────────────────────────────
-- 3. SPOT CHECK
-- Trace a single customer across all related tables
-- to verify field mapping and join integrity
-- ────────────────────────────────────────
SELECT
    c.full_name,
    c.region,
    u.upi_id,
    u.bank_name,
    t.transaction_id,
    t.amount,
    t.status,
    t.timestamp
FROM customer_master c
JOIN upi_account_details u   ON c.customer_id = u.customer_id
JOIN upi_transaction_history t ON u.upi_id   = t.upi_id
WHERE c.customer_id = 'cust100001'  -- swap in any customer_id to spot check
LIMIT 10;