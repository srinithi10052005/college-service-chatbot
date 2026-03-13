-- =========================================================
-- FULL DATABASE FOR COLLEGE_QUERY_CHATBOT (college_db)
-- Tables: modules, policies, chatbot_intents
-- Includes: Attendance, Fees, Leave, Outpass, Medical Leave, TC, Admission
-- =========================================================

-- 0) Create and use database
CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;

-- (Optional) If you want to re-run fresh each time, uncomment below:
-- SET FOREIGN_KEY_CHECKS = 0;
-- DROP TABLE IF EXISTS chatbot_intents;
-- DROP TABLE IF EXISTS policies;
-- DROP TABLE IF EXISTS modules;
-- SET FOREIGN_KEY_CHECKS = 1;

-- 1) Modules table
CREATE TABLE IF NOT EXISTS modules (
    module_id INT PRIMARY KEY AUTO_INCREMENT,
    module_name VARCHAR(50) NOT NULL UNIQUE
);

-- 2) Policies table
CREATE TABLE IF NOT EXISTS policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    module_id INT NOT NULL,
    policy_title VARCHAR(150) NOT NULL,
    policy_description TEXT,
    value_numeric DECIMAL(10,2),
    value_text VARCHAR(100),
    fine_applicable BOOLEAN DEFAULT FALSE,
    installment_allowed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 3) Chatbot intents table
CREATE TABLE IF NOT EXISTS chatbot_intents (
    intent_id INT PRIMARY KEY AUTO_INCREMENT,
    module_id INT NOT NULL,
    keywords VARCHAR(255) NOT NULL,
    user_question TEXT,
    response TEXT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 4) Insert modules
INSERT IGNORE INTO modules (module_name)
VALUES ('Attendance'), ('Fees'), ('Leave'), ('Certificate'), ('Admission');

-- 5) Insert policies
INSERT INTO policies
(module_id, policy_title, policy_description, value_numeric, value_text, fine_applicable, installment_allowed)
VALUES

(1, 'Minimum Attendance Percentage',
 'Students must maintain minimum attendance to write exams.',
 75, '75%', FALSE, FALSE),

(1, 'Maximum Leave Allowed',
 'Maximum leave allowed in a 90-day semester.',
 20, '20 days', FALSE, FALSE),

(1, 'Minimum Days Required',
 'Minimum working days required out of 90 days.',
 60, '60 days', FALSE, FALSE);

-- Fees
(2, 'Fee Last Date',
 'Refer college website for  the last date for fee payment.',
 NULL, 'College website', TRUE, TRUE),

(2, 'Late Payment Fine',
 'Fine applicable after deadline.',
 NULL, 'Fine Applicable', TRUE, TRUE),

(2, 'Online Payment System',
 'Fees must be paid online. Duplicate receipt will be generated.',
 NULL, 'Online Payment Only', FALSE, TRUE),

(2, 'Installment Facility',
 'Installment request allowed with prior approval.',
 NULL, 'Installment Possible', FALSE, TRUE),

-- Leave
(3, 'Medical Leave Procedure',
 'Medical certificate must be submitted to department and office.',
 NULL, 'Medical Certificate Required', FALSE, FALSE),

(3, 'Long Absence Rule',
 'Long absence may result in exam ineligibility or year break.',
 NULL, 'Possible Year Break', FALSE, FALSE),

(3, 'Outpass Procedure',
 'Students must obtain permission from Class Advisor and HOD before leaving campus. Entry must be recorded in the outpass register.',
 NULL, 'Advisor + HOD Approval Required', FALSE, FALSE),

-- Certificate
(4, 'Transfer Certificate Procedure',
 'Submit written request with HOD signature and fee clearance.',
 NULL, 'Written Application Required', FALSE, FALSE),

-- Admission
(5, 'Admission Confirmation',
 'Admission confirmed only after selection mail and fee payment.',
 NULL, 'Formalities Mandatory', FALSE, FALSE);

-- 6) Insert chatbot intents (questions + answers)
INSERT INTO chatbot_intents (module_id, keywords, user_question, response)
VALUES
-- Attendance
(1, 'minimum attendance percentage required',
 'What is the minimum attendance required?',
 'Minimum attendance required is 75%. You must attend at least 60 out of 90 working days.'),

(1, 'how many days leave allowed',
 'How many leave days can I take?',
 'Maximum 20 days leave is allowed in a semester.'),

(1, 'low attendance exam eligible',
 'Can I write exam with low attendance?',
 'If attendance is below 75%, you must apply for condonation as per college rules.'),

-- Fees
(2, 'last date fee payment',
 'What is the last date for fee payment?',
 'The 10th is the last date. Payment after that may attract fine.'),

(2, 'online fee payment receipt',
 'How should I pay the fees?',
 'Fees must be paid online. Duplicate receipt will be generated automatically.'),

(2, 'installment payment allowed',
 'Can I pay fees in installments?',
 'Yes, installment facility is available with prior approval.'),

(2, 'late fee fine',
 'Is fine applicable for late fee payment?',
 'Yes. Fine is applicable if fee is paid after the due date.'),

-- Leave
(3, 'medical leave procedure',
 'What is the procedure for medical leave?',
 'Submit medical certificate to your department and inform the office.'),

(3, 'long absence more than one month',
 'What happens if I take long leave?',
 'Long absence may result in exam ineligibility or year break.'),

(3, 'outpass leave campus gate pass permission',
 'How to apply for outpass?',
 'To get an outpass, you must obtain permission from your Class Advisor and HOD. Your details must be entered in the outpass register before leaving the campus.'),

-- Certificate
(4, 'transfer certificate apply',
 'How to apply for Transfer Certificate?',
 'Submit written application with HOD signature and fee clearance.'),

-- Admission
(5, 'admission confirmation process',
 'When is my admission confirmed?',
 'Admission is confirmed only after receiving selection mail and completing fee payment.');

