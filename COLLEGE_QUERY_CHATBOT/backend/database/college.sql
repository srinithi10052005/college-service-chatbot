## Database Setup

1. Open XAMPP and start Apache and MySQL.
2. Open phpMyAdmin.
3. Create a database named `college_db`.
4. Import the file `database/college_db.sql`.
5. Run the chatbot project.

CREATE DATABASE IF NOT EXISTS college_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE college_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS admin_services;
DROP TABLE IF EXISTS attendance_categories;
DROP TABLE IF EXISTS chatbot_intents;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS student_requests;
DROP TABLE IF EXISTS modules;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
-- 1. MODULES
-- =========================
CREATE TABLE modules (
    module_id INT AUTO_INCREMENT PRIMARY KEY,
    module_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO modules (module_id, module_name) VALUES
(1, 'General'),
(2, 'Fees'),
(3, 'Leave'),
(4, 'Certificate'),
(5, 'Admission'),
(6, 'Attendance');

-- =========================
-- 2. CHATBOT INTENTS
-- =========================
CREATE TABLE chatbot_intents (
    intent_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    language VARCHAR(20) NOT NULL,
    intent_name VARCHAR(100) NOT NULL,
    keywords TEXT NOT NULL,
    response TEXT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO chatbot_intents (intent_id, module_id, language, intent_name, keywords, response) VALUES

-- Greeting
(1, 1, 'English', 'greeting',
'hi, hello, hey, good morning, good afternoon, good evening',
'👋 Welcome to SDNB ASKNOVA. I am your service assistant. How can I help you today?'),

(2, 1, 'Tamil', 'greeting',
'வணக்கம், ஹாய், ஹலோ, காலை வணக்கம், மாலை வணக்கம்',
'👋 எஸ்டிஎன்பி ASKNOVA-க்கு வரவேற்கிறோம். நான் உங்கள் சேவை உதவியாளர். உங்கள் கேள்விகளுக்கு உதவ தயாராக உள்ளேன்.'),

-- Outpass
(3, 3, 'English', 'outpass',
'outpass, out pass, how to get outpass, outpass procedure, gate pass, leave permission, campus leave, permission to leave, permission to go outside, campus exit permission, go outside permission, exit campus',
'Outpass Procedure:
1. Get permission from your Class Incharge
2. Get approval from the HOD
3. Enter your details in the outpass register
4. Show the outpass at the gate/security
5. Then you can leave the campus'),

(4, 3, 'Tamil', 'outpass',
'அவுட்பாஸ், வெளியே செல்ல அனுமதி, outpass procedure',
'அவுட்பாஸ் நடைமுறை:
1. முதலில் உங்கள் Class Incharge-ிடம் அனுமதி பெற வேண்டும்
2. அதன் பிறகு HOD-ிடம் அனுமதி பெற வேண்டும்
3. Outpass register-ல் பதிவு செய்ய வேண்டும்
4. Gate-ல் outpass காட்ட வேண்டும்
5. அதன் பிறகு வெளியே செல்லலாம்'),

-- Bonafide main menu
(5, 4, 'English', 'bonafide',
'bonafide',
'There are multiple Bonafide Certificates available:

1. Course Bonafide
2. Passport Bonafide
3. Bonafide Without Fee Payment
4. General Bonafide Certificate

👉 Please type:
- course bonafide
- passport bonafide
- general bonafide certificate
- bonafide without fee'),

(6, 4, 'Tamil', 'bonafide',
'போனாபைடு, போனாபைடு சான்றிதழ்',
'பல வகையான Bonafide Certificates உள்ளன:

1. Course Bonafide
2. Passport Bonafide
3. Fee இல்லாமல் Bonafide
4. General Bonafide Certificate

👉 தயவு செய்து type செய்யவும்:
- course bonafide
- passport bonafide
- general bonafide certificate
- bonafide without fee'),

-- TC passout
(7, 4, 'English', 'tc_procedure',
'tc, tc procedure, transfer certificate, how to get tc, tc process, certificate process, tc for passout, passout tc',
'Transfer Certificate Procedure (Pass Out Students):

1. Visit your department
2. Submit TC application
3. Get HOD signature
4. Complete office clearance
5. Collect TC from Admin Office'),

(8, 4, 'Tamil', 'tc_procedure',
'tc, transfer certificate, tc நடைமுறை',
'TC பெறும் நடைமுறை:

1. துறைக்கு சென்று விண்ணப்பிக்க வேண்டும்
2. HOD கையொப்பம் பெற வேண்டும்
3. Office clearance முடிக்க வேண்டும்
4. Admin Office-ல் TC பெறலாம்'),

-- Missing ID
(9, 3, 'English', 'missing_id',
'missing id, id card lost, lost id, lost id card, id lost, duplicate id, duplicate id card, id card procedure, missing id procedure',
'Missing ID Card Procedure:
1. Inform Class Incharge and HOD
2. Give a letter to the department
3. Submit it to the Admin Office
4. Pay Rs.250 for reissue
5. New ID card will be issued within 1 week'),

(10, 3, 'Tamil', 'missing_id',
'மிஸ்ஸிங் ஐடி, அடையாள அட்டை தொலைந்தது, id card காணவில்லை',
'ID Card காணாமல் போனால்:
1. Class Incharge மற்றும் HOD-க்கு தகவல் சொல்ல வேண்டும்
2. துறைக்கு கடிதம் தர வேண்டும்
3. Admin Office-ல் சமர்ப்பிக்க வேண்டும்
4. ரூ.250 கட்டணம் செலுத்த வேண்டும்
5. புதிய ID card ஒரு வாரத்தில் கிடைக்கும்'),

-- Exam eligibility
(11, 6, 'English', 'exam_eligibility',
'write exam, exam procedure, exam eligibility, eligible to write exam, can i write exam, how to write exam, can i attend exam with low attendance',
'To write the exam, students must generally maintain the required attendance. If attendance is 75% or above, they are eligible. If it is between 65% and 74%, condonation may apply based on college rules.'),

(12, 6, 'Tamil', 'exam_eligibility',
'exam எழுத, exam eligibility, தேர்வு எழுதலாமா',
'தேர்வு எழுத மாணவர்கள் தேவையான attendance வைத்திருக்க வேண்டும். 75% மற்றும் அதற்கு மேல் இருந்தால் தேர்வு எழுதலாம். 65% முதல் 74% வரை இருந்தால் condonation விதிமுறை பொருந்தலாம்.'),

-- TC discontinued
(13, 4, 'English', 'tc_discontinued',
'tc discontinued, tc for discontinued, discontinued tc, dropout tc, left course tc',
'Transfer Certificate Procedure (Discontinued Students):

1. Inform your department
2. Submit written request for TC
3. Complete clearance process
4. Collect TC from Admin Office'),

(14, 4, 'Tamil', 'tc_discontinued',
'படிப்பை நிறுத்தினால் tc, discontinued tc, dropout tc, transfer certificate',
'படிப்பை நிறுத்திய மாணவர்களுக்கான TC நடைமுறை:
1. துறைக்கு தகவல் தெரிவிக்க வேண்டும்
2. TC பெற விண்ணப்பம் எழுத வேண்டும்
3. தேவையான clearance முடிக்க வேண்டும்
4. Admin Office மூலம் Transfer Certificate பெறலாம்'),

-- General bonafide
(15, 4, 'English', 'bonafide_general',
'general bonafide certificate, general bonafide, student bonafide',
'General Bonafide Certificate:

This certificate is used as proof that you are a student of the college.

Bonafide Certificate Procedure:
1. Go to the department and collect the bonafide form.
2. Fill in the required details.
3. Get seal from the department and union.
4. Submit the form to the admin office.'),

-- Course bonafide
(16, 4, 'English', 'course_bonafide',
'course bonafide',
'Course Bonafide:

This certificate is used for course-related verification.

Procedure:
1. Visit the Admin Office
2. Submit the request
3. Complete the required verification
4. Collect the certificate after processing'),

-- Passport bonafide
(17, 4, 'English', 'passport_bonafide',
'passport bonafide',
'Passport Bonafide:

This certificate is required for passport process.

Procedure:
1. Visit the Admin Office
2. Submit the request
3. Complete the verification process
4. Pay the required fee
5. Collect the certificate after processing

Fee: Rs.50'),

-- Bonafide without fee
(18, 4, 'English', 'bonafide_without_fee',
'bonafide without fee, bonafide without fee payment, no fee bonafide',
'Bonafide Without Fee Payment:

This bonafide can be requested without fee payment only with special permission.

Procedure:
1. Visit the Admin Office
2. Explain the reason for request
3. Get approval from the higher authority
4. Submit the required form
5. Collect the certificate after approval'),

-- Condonation fee
(19, 6, 'English', 'attendance_condonation_fee',
'condonation fee, attendance condonation fee, low attendance fee, fee for attendance shortage',
'Students with attendance between 65% and 74% must pay a condonation fee of Rs.250.'),

(20, 6, 'Tamil', 'attendance_condonation_fee',
'condonation fee, attendance fee, அபராத கட்டணம், attendance குறைவு fee',
'65% முதல் 74% வரை attendance உள்ளவர்கள் ரூ.250 condonation fee செலுத்த வேண்டும்.'),

-- Marksheet lost
(21, 4, 'English', 'marksheet_lost',
'marksheet lost, lost marksheet, my marksheet is lost, certificate lost',
'If your marksheet is lost, you can apply for a duplicate certificate. Charges depend on the year gap:
1 year gap: Rs.1000
2 year gap: Rs.2000
3 year gap: Rs.3000
4 year gap: Rs.4000
5 year gap: Rs.5000'),

(22, 4, 'Tamil', 'marksheet_lost',
'மார்க்ஷீட் தொலைந்தது, marksheet lost, certificate lost',
'மார்க்ஷீட் தொலைந்தால் duplicate certificateக்கு விண்ணப்பிக்கலாம். ஆண்டு இடைவெளிக்கு ஏற்ப கட்டணம் மாறும்.');

-- =========================
-- 3. POLICIES
-- =========================
CREATE TABLE policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    language VARCHAR(20) NOT NULL DEFAULT 'English',
    policy_title VARCHAR(150) NOT NULL,
    policy_description TEXT,
    value_numeric DECIMAL(10,2) NULL,
    value_text VARCHAR(100) NULL,
    fine_applicable BOOLEAN DEFAULT FALSE,
    installment_allowed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO policies (policy_id, module_id, language, policy_title, policy_description, value_numeric, value_text, fine_applicable, installment_allowed) VALUES
(1, 2, 'English', 'Late Fee', 'Fine applicable after due date', NULL, 'Fine Applicable', TRUE, TRUE),
(2, 2, 'Tamil', 'தாமத கட்டணம்', 'கட்டணத்தின் கடைசி தேதிக்குப் பிறகு அபராதம் விதிக்கப்படலாம்.', NULL, 'அபராதம் பொருந்தும்', TRUE, TRUE),
(3, 3, 'English', 'Medical Leave', 'Medical certificate required', NULL, 'Medical Certificate Required', FALSE, FALSE),
(4, 3, 'Tamil', 'மருத்துவ விடுப்பு', 'மருத்துவச் சான்றிதழ் துறைக்கு சமர்ப்பிக்க வேண்டும்.', NULL, 'மருத்துவச் சான்றிதழ் அவசியம்', FALSE, FALSE),
(5, 4, 'English', 'Transfer Certificate', 'Students must complete department and office clearance before receiving TC.', NULL, 'Clearance Required', FALSE, FALSE),
(6, 4, 'Tamil', 'மாற்றுச் சான்றிதழ்', 'TC பெற துறை மற்றும் அலுவலக clearance முடிக்க வேண்டும்.', NULL, 'Clearance அவசியம்', FALSE, FALSE);

-- =========================
-- 4. ATTENDANCE CATEGORIES
-- =========================
CREATE TABLE attendance_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_code VARCHAR(5) NOT NULL,
    min_percent INT NOT NULL,
    max_percent INT NOT NULL,
    language VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    response TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO attendance_categories (id, category_code, min_percent, max_percent, language, title, response) VALUES
(1, 'A', 75, 100, 'English', 'Category A', 'Eligible for exams'),
(2, 'B', 65, 74, 'English', 'Category B', 'Condonation fee Rs.250'),
(3, 'C', 50, 64, 'English', 'Category C', 'Not allowed exam'),
(4, 'D', 1, 49, 'English', 'Category D', 'Repeat course'),
(5, 'E', 0, 0, 'English', 'Category E', 'Rejoin required'),
(6, 'A', 75, 100, 'Tamil', 'வகை A', 'தேர்வு எழுத தகுதி உள்ளது'),
(7, 'B', 65, 74, 'Tamil', 'வகை B', 'ரூ.250 condonation fee செலுத்த வேண்டும்'),
(8, 'C', 50, 64, 'Tamil', 'வகை C', 'தேர்வு எழுத அனுமதி இல்லை'),
(9, 'D', 1, 49, 'Tamil', 'வகை D', 'Course மீண்டும் படிக்க வேண்டும்'),
(10, 'E', 0, 0, 'Tamil', 'வகை E', 'மீண்டும் சேர வேண்டும்');

-- =========================
-- 5. STUDENT REQUESTS
-- =========================
CREATE TABLE student_requests (
    id INT PRIMARY KEY,
    topic VARCHAR(255),
    year_of_discontinuation VARCHAR(50),
    reason VARCHAR(100),
    purpose TEXT,
    year_gap INT,
    amount DECIMAL(10,2),
    notes TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO student_requests (id, topic, year_of_discontinuation, reason, purpose, year_gap, amount, notes) VALUES
(1, 'Dropout', 'Mention year', 'Marriage / Others', 'Specify purpose', NULL, NULL, 'All details required'),
(2, 'Medium of Instruction (MOI)', NULL, NULL, 'For job/higher studies', NULL, 1000.00, 'Charges applicable'),
(3, 'Missing TC / Marksheets', NULL, NULL, 'Request for duplicate certificates', 1, 1000.00, '1 year gap'),
(4, 'Missing TC / Marksheets', NULL, NULL, 'Request for duplicate certificates', 2, 2000.00, '2 year gap'),
(5, 'Missing TC / Marksheets', NULL, NULL, 'Request for duplicate certificates', 3, 3000.00, '3 year gap'),
(6, 'Missing TC / Marksheets', NULL, NULL, 'Request for duplicate certificates', 4, 4000.00, '4 year gap'),
(7, 'Missing TC / Marksheets', NULL, NULL, 'Request for duplicate certificates', 5, 5000.00, '5 year gap'),
(8, 'Missing TC / Marksheets', NULL, NULL, 'Not applicable after 5 years gap', NULL, NULL, 'Service not available if gap > 5 years'),
(9, 'Bonafide Certificate (Passed Out Student)', NULL, NULL, 'Proof of being a student', NULL, 200.00, NULL),
(10, 'Genuineness Certificate', NULL, NULL, 'Certificate verification', NULL, 500.00, NULL),
(11, 'Disability Student Exemption', NULL, NULL, 'Request for exemption', NULL, NULL, 'Submit proof for approval');

-- =========================
-- 6. ADMIN SERVICES
-- =========================
CREATE TABLE admin_services (
    id INT PRIMARY KEY,
    service_name VARCHAR(255),
    issued_by VARCHAR(100),
    purpose TEXT,
    requirements TEXT,
    fees DECIMAL(10,2),
    notes TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO admin_services (id, service_name, issued_by, purpose, requirements, fees, notes) VALUES
(1, 'Bonafide Certificate', 'Admin Office', 'Proof of student status', 'Request form submission', NULL, 'Basic verification'),
(2, 'Fee Structure Certificate', 'Admin Office', 'Provides annual fee details', 'Request form submission', NULL, 'Proof required'),
(3, 'Scholarship Form', 'Admin Office', 'Apply for scholarship', 'Approval from admin/team', NULL, 'Verification needed'),
(4, 'Course Bonafide', 'Admin Office', 'Course-related verification', 'Request submission', NULL, NULL),
(5, 'Student Outpass', 'Admin Office', 'Permission to leave campus', 'Student request', NULL, 'Maintain proper proof'),
(6, 'Passport Bonafide', 'Admin Office', 'Required for passport process', 'Request submission', 50.00, 'Added in exam fees'),
(7, 'Medium of Instruction', 'Admin Office', 'Certificate stating language (English)', 'Request submission', NULL, NULL),
(8, 'Attendance Certificate', 'Admin Office', 'Proof of previous semester attendance', 'Record verification', NULL, NULL),
(9, 'First Graduation Certificate', 'Admin Office', 'Proof of first graduate status', 'Submit declaration if not available', NULL, 'Alternative proof accepted'),
(10, 'Napkin Service', 'College Facility', 'Sanitary napkin availability', 'Token system', 0.00, 'No charges'),
(11, 'Subsidized Food', 'Canteen', 'Affordable student meal', 'Token required', 10.00, 'Includes sambar rice, pickle, vegetables'),
(12, 'Complaint Service', 'Union/Admin Office', 'Report issues or complaints', NULL, NULL, 'Students can complain if issues arise'),
(13, 'Missing Items Report', 'Admin/Union Office', 'Report lost items', 'Submit complaint', NULL, 'Recorded as Missed Note'),
(14, 'Lost ID Card', 'Admin Office', 'Reissue ID card', 'Apply with details', 250.00, 'Bonafide required'),
(15, 'Bonafide Without Fee Payment', 'Admin Office', 'Request bonafide without paying fees', 'Special permission required', NULL, 'Approval needed'),
(16, 'Single Parent Support', 'Admin / Staff', 'Support for single parent students', 'Proof required', NULL, 'Staff approval needed'),
(17, 'Continuous Study / Discontinuation', 'Admin Office', 'Discontinue and resume study', 'Request submission', NULL, 'No break allowed'),
(18, 'Physically Challenged Support', 'Admin Office / COE', 'Support for physically challenged students', 'Medical proof + COE permission', NULL, 'HOD letter required');


-- =============================================
-- STEP 1: Add dropout_reasons table
-- Run this in phpMyAdmin > college_db > SQL
-- =============================================

CREATE TABLE IF NOT EXISTS dropout_reasons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    reason_code VARCHAR(10) NOT NULL UNIQUE,
    reason_text VARCHAR(255) NOT NULL,
    reason_tamil VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO dropout_reasons (category, reason_code, reason_text, reason_tamil) VALUES

-- Academic
('Academic', 'AC01', 'Failed in exams repeatedly',         'தேர்வில் திரும்பவும் தோல்வி'),
('Academic', 'AC02', 'Unable to cope with studies',        'படிப்பை தொடர முடியவில்லை'),
('Academic', 'AC03', 'Change of course or institution',    'வேறு படிப்பு / கல்லூரிக்கு மாறுதல்'),
('Academic', 'AC04', 'Transferred to another college',     'வேறு கல்லூரிக்கு இடமாற்றம்'),

-- Personal / Family
('Personal', 'PE01', 'Marriage',                           'திருமணம்'),
('Personal', 'PE02', 'Family responsibilities',            'குடும்ப பொறுப்புகள்'),
('Personal', 'PE03', 'Death of a parent or family member', 'குடும்பத்தினர் இறப்பு'),
('Personal', 'PE04', 'Relocation to another city or state','வேறு நகரம் / மாநிலத்திற்கு இடம் மாறுதல்'),

-- Financial
('Financial', 'FI01', 'Unable to pay fees',               'கட்டணம் செலுத்த இயலவில்லை'),
('Financial', 'FI02', 'Financial hardship or family income loss', 'நிதி சிரமம்'),
('Financial', 'FI03', 'Need to work to support family',   'குடும்பத்தை ஆதரிக்க வேலைக்கு செல்வது'),

-- Health
('Health',    'HE01', 'Long-term medical illness',         'நீண்ட நாள் நோய்'),
('Health',    'HE02', 'Mental health issues',              'மன நலப் பிரச்சினை'),
('Health',    'HE03', 'Physical disability or accident',   'உடல் ஊனம் / விபத்து'),

-- Career / Opportunity
('Career',    'CA01', 'Got a job',                         'வேலை கிடைத்தது'),
('Career',    'CA02', 'Pursuing competitive exams (UPSC/TNPSC)', 'போட்டித் தேர்வுகளுக்கு படிக்கிறேன்'),
('Career',    'CA03', 'Started own business',              'சொந்த தொழில் தொடங்கியது'),
('Career',    'CA04', 'Selected in armed forces or government service', 'அரசு / ராணுவ சேவையில் சேர்ந்தது'),

-- Other
('Other',     'OT01', 'Personal reasons',                  'தனிப்பட்ட காரணம்'),
('Other',     'OT02', 'Others',                            'மற்றவை');


-- =============================================
-- STEP 2: Update student_requests dropout row
-- =============================================

UPDATE student_requests
SET reason = 'See dropdown: AC01-OT02'
WHERE topic = 'Dropout';


-- =============================================
-- VERIFY: Check the new table
-- =============================================

SELECT category, reason_code, reason_text, reason_tamil
FROM dropout_reasons
ORDER BY category, reason_code;

