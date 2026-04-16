-- CORRECTED & FIXED DATABASE SETUP
-- All inline comments removed from INSERT statements
-- All quotes properly escaped
-- All rows have correct number of values

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
DROP TABLE IF EXISTS dropout_reasons;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
-- 1. MODULES TABLE
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
-- 2. CHATBOT INTENTS TABLE
-- =========================
CREATE TABLE chatbot_intents (
    intent_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    language VARCHAR(20) NOT NULL,
    intent_name VARCHAR(100) NOT NULL,
    keywords TEXT NOT NULL,
    response LONGTEXT NOT NULL,
    processing_time VARCHAR(50) DEFAULT NULL,
    fees DECIMAL(10,2) DEFAULT NULL,
    office_location VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO chatbot_intents (intent_id, module_id, language, intent_name, keywords, response, processing_time, fees, office_location) VALUES
(1, 1, 'English', 'greeting', 'hi, hello, hey, good morning, good afternoon, good evening', 'Welcome to SDNB ASKNOVA. I am your service assistant. How can I help you today?', NULL, NULL, NULL),

(2, 1, 'Tamil', 'greeting', 'வணக்கம், ஹாய், ஹலோ, காலை வணக்கம், மாலை வணக்கம்', 'எஸ்டிஎன்பி ASKNOVA-க்கு வரவேற்கிறோம். நான் உங்கள் சேவை உதவியாளர். உங்கள் கேள்விகளுக்கு உதவ தயாராக உள்ளேன்.', NULL, NULL, NULL),

(3, 3, 'English', 'outpass', 'outpass, out pass, how to get outpass, outpass procedure, gate pass, leave permission, campus leave, permission to leave, permission to go outside, campus exit permission, go outside permission, exit campus', 'Outpass Procedure (Processing: 2-4 hours): Step 1: Visit your Class Incharge in your department. Step 2: Get written permission from HOD (Department Block, 2nd Floor). Step 3: Visit Admin Office (Main Building, Ground Floor) with approval letter. Step 4: Enter your details in outpass register with OUT and IN times. Step 5: Show outpass at main gate to security. Step 6: Return outpass upon returning to campus. Contact: Admin Office - Extension 105 (Mon-Fri, 9:00 AM - 4:30 PM)', '2-4 hours', NULL, 'Admin Office, Main Building, Ground Floor'),

(4, 3, 'Tamil', 'outpass', 'அவுட்பாஸ், வெளியே செல்ல அனுமதி, outpass procedure', 'அவுட்பாஸ் நடைமுறை (செயல்படுத்தும் நேரம்: 2-4 மணிநேரம்): படி 1: உங்கள் Class Incharge-ஐ உங்கள் துறையில் சந்தியுங்கள். படி 2: HOD-ஐ தொடர்புகொண்டு அனுமதிப்பத்திரம் பெறுங்கள் (துறை ப்ளாக், 2வது மாடி). படி 3: அனுமதிப்பத்திரத்துடன் Admin Office-ற்குச் செல்லுங்கள் (முதன்மை கட்டடம், தாழ்வாரம்). படி 4: அவுட்பாஸ் பதிவேட்டில் நுழைந்த மற்றும் வெளியேறிய நேரம் பதிவு செய்யுங்கள். படி 5: பாதுகாப்பாளரிடம் முதன்மை வாயிலில் அவுட்பாஸ் காட்டுங்கள். படி 6: வெளியேறுவதற்கு முன் Admin Office-ற்கு அவுட்பாஸ் திருப்பி அளியுங்கள். தொடர்பு: Admin Office - நீட்சி 105 (திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM)', '2-4 மணிநேரம்', NULL, 'Admin Office, முதன்மை கட்டடம், தாழ்வாரம்'),

(5, 4, 'English', 'bonafide', 'bonafide', 'Multiple Bonafide Certificates available: 1. General Bonafide Certificate (Free) - Processing: 2-3 days - Proof of student status. 2. Course Bonafide (Free) - Processing: 3-4 days - Current course enrollment verification. 3. Passport Bonafide (Rs.50) - Processing: 2-3 days - For passport applications. 4. Bonafide Without Fee (Free with permission) - For genuine financial hardship. Please type: general bonafide, course bonafide, passport bonafide, or bonafide without fee. Location: Admin Office, Main Building, Ground Floor. Timings: Mon-Fri, 9:00 AM - 4:30 PM. Contact: Extension 105', NULL, NULL, 'Admin Office, Main Building, Ground Floor'),

(6, 4, 'Tamil', 'bonafide', 'போனாபைடு, போனாபைடு சான்றிதழ்', 'பல வகையான Bonafide Certificates உள்ளன: 1. General Bonafide Certificate (இலவசம்) - 2-3 நாட்கள். 2. Course Bonafide (இலவசம்) - 3-4 நாட்கள். 3. Passport Bonafide (Rs.50) - 2-3 நாட்கள். 4. Fee இல்லாமல் Bonafide (இலவசம், சிறப்பு அனுமதி) - நிதி சிரமத்தில் உள்ளவர்களுக்கு. தயவு செய்து type செய்யவும்: general bonafide, course bonafide, passport bonafide, bonafide without fee. இடம்: Admin Office, முதன்மை கட்டடம், தாழ்வாரம். நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM. தொடர்பு: நீட்சி 105', NULL, NULL, 'Admin Office, Main Building, Ground Floor'),

(7, 4, 'English', 'tc_procedure', 'tc, tc procedure, transfer certificate, how to get tc, tc process, certificate process, tc for passout, passout tc', 'Transfer Certificate Procedure (Pass Out Students) - Processing: 7-10 working days. Step 1: Visit Department Office with application form. Step 2: Get HOD signature and stamp. Step 3: Get clearance from Library (return all books), Hostel (if resident). Step 4: Complete office clearance at Admin Office with receipts. Step 5: Submit final documents to Admin Office. Step 6: Collect TC Certificate after 7-10 days. Locations: Department Block (1st Floor), Library (GB Block), Hostel (Behind Gate), Admin Office (Main Building, Ground Floor). Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM', '7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(8, 4, 'Tamil', 'tc_procedure', 'tc, transfer certificate, tc நடைமுறை', 'Transfer Certificate பெறும் நடைமுறை (பட்டம் பெற்ற மாணவர்கள்) - 7-10 வேலை நாட்கள். படி 1: விண்ணப்பப் படிவத்துடன் துறை அலுவலகத்திற்குச் செல்லுங்கள். படி 2: HOD கையொப்பம் மற்றும் முத்திரை பெறுங்கள். படி 3: நூலகம் (புத்தகங்களை திருப்பி அளியுங்கள்), விடுதி (பொருந்தினால்) இலிருந்து சரியாக்கல் பெறுங்கள். படி 4: Admin Office-ற்கு ரசீதுகளுடன் அலுவலக சரியாக்கல் முடிக்கவும். படி 5: Admin Office-ற்கு இறுதி ஆவணங்களை சமர்ப்பிக்கவும். படி 6: 7-10 வேலை நாட்களுக்குப் பிறகு TC சான்றிதழ் சேகரிக்கவும். தொடர்பு: Admin Office - நீட்சி 105. நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM', '7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(9, 3, 'English', 'missing_id', 'missing id, id card lost, lost id, lost id card, id lost, duplicate id, duplicate id card, id card procedure, missing id procedure', 'Missing ID Card Reissue Procedure - Processing: 5-7 working days, Fee: Rs.250. Step 1: Inform Class Incharge (within 24 hours). Step 2: Inform HOD in writing. Step 3: Visit Admin Office (Main Building, Ground Floor) with Lost ID Declaration Form, Class Incharge notification, HOD Approval Letter. Step 4: Pay Rs.250 at Cash Counter. Step 5: Get provisional ID receipt (valid 15 days). Step 6: Report to Campus Security with receipt. Step 7: Collect new ID after 5-7 days. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM. Note: Without ID, entry may be restricted at gates', '5-7 working days', 250.00, 'Admin Office, Main Building, Ground Floor'),

(10, 3, 'Tamil', 'missing_id', 'மிஸ்ஸிங் ஐடி, அடையாள அட்டை தொலைந்தது, id card காணவில்லை', 'ID அட்டை மீண்டும் வெளியீடு செய்யும் நடைமுறை - 5-7 வேலை நாட்கள், கட்டணம்: Rs.250. படி 1: Class Incharge-க்கு தகவல் சொல்லுங்கள் (24 மணிநேரத்திற்குள்). படி 2: HOD-க்கு எழுத்துப்பூர்வ தகவல் சொல்லுங்கள். படி 3: Admin Office-ற்குச் செல்லுங்கள் இழந்த ID பிரகடன படிவம், Class Incharge அறிவிப்பு, HOD அனுமதி கடிதம் உடன். படி 4: Cash Counter-ல் Rs.250 செலுத்துங்கள். படி 5: 15 நாட்கள் செல்லுபடியாகும் தற்காலிக ID ரசீது பெறுங்கள். படி 6: Campus Security-ற்கு ரசீதுடன் புகாரளியுங்கள். படி 7: 5-7 வேலை நாட்களுக்குப் பிறகு புதிய ID சேகரிக்கவும். தொடர்பு: நீட்சி 105. நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM. குறிப்பு: ID இல்லாமல் வாயிலில் நுழைய தடுக்கப்படலாம்', '5-7 working days', 250.00, 'Admin Office, Main Building, Ground Floor'),

(11, 6, 'English', 'exam_eligibility', 'write exam, exam procedure, exam eligibility, eligible to write exam, can i write exam, how to write exam, can i attend exam with low attendance', 'Exam Eligibility Based on Attendance: Category A (75% or more): ELIGIBLE - Write exam without restrictions. Category B (65-74%): ELIGIBLE with Condonation - Pay Rs.250 fee 3 days before exam. Category C (50-64%): NOT ELIGIBLE - Repeat course next semester. Contact HOD for re-registration. Category D (Less than 50%): NOT ELIGIBLE - Repeat entire course. Complete re-registration required. Condonation Payment Location: Admin Office, Cash Counter. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM. Tip: Maintain 75% attendance to avoid complications', NULL, 250.00, 'Admin Office, Main Building, Ground Floor'),

(12, 6, 'Tamil', 'exam_eligibility', 'exam எழுத, exam eligibility, தேர்வு எழுதலாமா', 'Attendance-ல் அடிப்படையாக தேர்வு தகுதி: Category A (75% அல்லது அதற்கு மேல்): தகுதி உள்ளது - கட்டுப்பாடு இல்லாமல் தேர்வு எழுதலாம். Category B (65-74%): Condonation உடன் தகுதி - Rs.250 fee தேர்வுக்கு 3 நாட்களுக்கு முன் செலுத்துங்கள். Category C (50-64%): தகுதி இல்லை - அடுத்த செமிஸ்டரில் மீண்டும் படிக்கவும். HOD-ஐ தொடர்புகொள்ளுங்கள். Category D (50% குறைவு): தகுதி இல்லை - முழு பாடம் மீண்டும் படிக்கவும். Condonation செலுத்தும் இடம்: Admin Office, Cash Counter. தொடர்பு: நீட்சி 105. நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM. குறிப்பு: 75% attendance வைத்திருங்கள்', NULL, 250.00, 'Admin Office, Main Building, Ground Floor'),

(13, 4, 'English', 'tc_discontinued', 'tc discontinued, tc for discontinued, discontinued tc, dropout tc, left course tc, drop out', 'Transfer Certificate Procedure (Discontinued/Dropout Students) - Processing: 7-10 working days. Step 1: Contact HOD with discontinuation letter. Step 2: Collect TC Application Form from Department Office. Step 3: Get approval from Class Incharge and HOD (Signature and Stamp). Step 4: Get clearance from Library (return all books). Step 5: Get Hostel clearance if resident. Step 6: Visit Admin Office with TC Form, HOD Letter, Library Clearance, Hostel Clearance (if applicable), Admission Document. Step 7: Pay pending fees if any. Step 8: Collect TC after 7-10 days. Submit reason for discontinuation. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM', '7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(14, 4, 'Tamil', 'tc_discontinued', 'படிப்பை நிறுத்தினால் tc, discontinued tc, dropout tc, transfer certificate', 'Transfer Certificate பெறும் நடைமுறை (நிறுத்திய மாணவர்கள்) - 7-10 வேலை நாட்கள். படி 1: நிறுத்தும் கடிதத்துடன் HOD-ஐ தொடர்புகொள்ளுங்கள். படி 2: துறை அலுவலகத்திலிருந்து TC விண்ணப்பப் படிவம் சேகரிக்கவும். படி 3: Class Incharge மற்றும் HOD இலிருந்து அனுமதி (கையொப்பம், முத்திரை). படி 4: நூலகத்திலிருந்து சரியாக்கல் (புத்தகங்களை திருப்பி). படி 5: விடுதி வாசியாக இருந்தால் விடுதி சரியாக்கல். படி 6: Admin Office-ற்கு ஆவணங்களுடன். படி 7: நிலுவைக் கட்டணம் செலுத்துங்கள். படி 8: 7-10 நாட்களுக்குப் பிறகு TC சேகரிக்கவும். தொடர்பு: நீட்சி 105. நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM', '7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(15, 4, 'English', 'bonafide_general', 'general bonafide certificate, general bonafide, student bonafide', 'General Bonafide Certificate - Processing: 2-3 working days, Fee: FREE. Purpose: Proof of student status, required for scholarships, educational loans, visa applications. Step 1: Visit Admin Office (Main Building, Ground Floor). Step 2: Collect General Bonafide Request Form. Step 3: Fill with registration number, name, department, year. Step 4: Visit Department for Class Incharge signature and seal. Step 5: Visit College Union for signature. Step 6: Return to Admin Office with completed form. Step 7: Collect after 2-3 days. Required: Valid ID Card, Filled Form, Department and Union seals. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM. No fees required', '2-3 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(16, 4, 'English', 'course_bonafide', 'course bonafide', 'Course Bonafide Certificate - Processing: 3-4 working days, Fee: FREE. Purpose: Verification of current course enrollment, required for semester admissions. Step 1: Visit Admin Office (Main Building, Ground Floor). Step 2: Fill Course Bonafide Request Form. Step 3: Provide semester details, registration number, course code and name. Step 4: Admin staff verify enrollment in system. Step 5: Collect after 3-4 days. Required Documents: Valid ID Card, Filled Request Form. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM', '3-4 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(17, 4, 'English', 'passport_bonafide', 'passport bonafide', 'Passport Bonafide Certificate - Processing: 2-3 working days, Fee: Rs.50. Purpose: Mandatory for passport applications, accepted by Ministry of External Affairs. Step 1: Visit Admin Office (Main Building, Ground Floor). Step 2: Collect Passport Bonafide Request Form. Step 3: Fill with full name, date of birth, registration number, current semester. Step 4: Attach ID copy and Admission Document copy. Step 5: Pay Rs.50 at Cash Counter. Step 6: Submit to Certificates Desk. Step 7: Collect after 2-3 days. Important: Name must match government ID. Certificate validity: 1 year. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM', '2-3 working days', 50.00, 'Admin Office, Main Building, Ground Floor'),

(18, 4, 'English', 'bonafide_without_fee', 'bonafide without fee, bonafide without fee payment, no fee bonafide', 'Bonafide Without Fee Payment - Processing: 3-5 working days (with approval), Fee: FREE (special permission only). Eligibility: Proven financial hardship, orphaned, single parent family, scholarship recipient, exceptional cases. Required: Request letter explaining waiver reason, financial proof (BPL Certificate or income proof), Valid ID Card, Admission Document. Process: Submit at Admin Office, forwarded to Class Incharge (verification), HOD (approval), Dean of Student Affairs. Final approval from Principal. Verification: 2-3 days, Approval: 1-2 days, Issue: 1 day. Important: Approval NOT automatic. Decision case-by-case. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM', '3-5 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(21, 4, 'English', 'marksheet_lost', 'marksheet lost, lost marksheet, my marksheet is lost, certificate lost, duplicate marksheet', 'Duplicate Marksheet/Certificate Procedure - Processing: 10-15 working days. Fee Structure (Based on Year Gap): 1 year = Rs.1000, 2 years = Rs.2000, 3 years = Rs.3000, 4 years = Rs.4000, 5 years = Rs.5000, After 5 years = University processing (4-6 weeks). Step 1: Visit Admin Office (Main Building, Ground Floor). Step 2: Collect Duplicate Certificate Request Form. Step 3: Fill with semester/exam year, subject codes, exam registration number. Step 4: Provide ID copy, Admission Document copy, Police FIR (if lost/stolen). Step 5: Pay fee at Cash Counter (Processing fee Rs.100 + Duplication fee based on year gap). Step 6: Submit form with receipts. Step 7: Admin verifies with University records. Step 8: Duplicate printed and issued. Important: Official government certification. Service not available if gap exceeds 5 years. Contact: Admin Office - Extension 105. Hours: Mon-Fri, 9:00 AM - 4:30 PM', '10-15 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(22, 4, 'Tamil', 'marksheet_lost', 'மார்க்ஷீட் தொலைந்தது, marksheet lost, certificate lost, duplicate marksheet', 'Duplicate மார்க்ஷீட்/சான்றிதழ் பெறும் நடைமுறை - 10-15 வேலை நாட்கள். கட்டணம் (ஆண்டு இடைவெளிக்கு): 1 ஆண்டு = Rs.1000, 2 = Rs.2000, 3 = Rs.3000, 4 = Rs.4000, 5 = Rs.5000, 5+ = பல்கலைக்கழகம் (4-6 வாரங்கள்). படி 1: Admin Office-ற்குச் செல்லுங்கள் (முதன்மை கட்டடம், தாழ்வாரம்). படி 2: Duplicate சான்றிதழ் கோரிக்கைப் படிவம் சேகரிக்கவும். படி 3: செமிஸ்டர்/தேர்வு ஆண்டு, பாடப் குறியீடுகள், தேர்வு பதிவு எண் நிரப்பிக்கவும். படி 4: ID நகல், சேர்க்கை நகல், போலீஸ் FIR (தேவையில்) வழங்குங்கள். படி 5: Cash Counter-ல் கட்டணம் செலுத்துங்கள் (Rs.100 செயல்படுத்தும் + duplicate fee). படி 6: ரசீதுகளுடன் சமர்ப்பிக்கவும். படி 7: Admin பல்கலைக்கழக பதிவுகளுடன் சரிபார்க்கும். படி 8: Duplicate அச்சிட வெளியீடு. Contact: நீட்சி 105. நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM', '10-15 working days', NULL, 'Admin Office, Main Building, Ground Floor');

-- =========================
-- 3. POLICIES TABLE
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
    due_date VARCHAR(50) DEFAULT NULL,
    office_location VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO policies (policy_id, module_id, language, policy_title, policy_description, value_numeric, value_text, fine_applicable, installment_allowed, due_date, office_location) VALUES
(1, 2, 'English', 'Semester Fee', 'Annual fee per semester', 50000.00, 'Due on registration', FALSE, TRUE, 'Before semester starts', 'Finance Office, Block-B'),
(2, 2, 'English', 'Late Fee', 'Fine applicable after due date (Rs.500 per day)', 500.00, 'Fine Applicable', TRUE, FALSE, '7 days after due date', 'Finance Office'),
(3, 2, 'English', 'Hostel Fee', 'Annual hostel charges for residents', 30000.00, 'Payable once a year', FALSE, FALSE, 'Before hostel registration', 'Hostel Office'),
(4, 2, 'Tamil', 'செமிஸ்টர் கட்டணம்', 'ஒரு செமிஸ்டருக்கு ஆண்டு கட்டணம்', 50000.00, 'பதிவுக்கு முன் செலுத்த வேண்டும்', FALSE, TRUE, 'செமிஸ்டர் தொடங்குவதற்கு முன்', 'Finance Office, Block-B'),
(5, 2, 'Tamil', 'தாமத கட்டணம்', 'கட்டணத்தின் கடைசி தேதிக்குப் பிறகு அபராதம் (Rs.500 நாளொன்றுக்கு)', 500.00, 'அபராதம் பொருந்தும்', TRUE, FALSE, 'கடைசி தேதிக்கு 7 நாட்களுக்குப் பிறகு', 'Finance Office'),
(6, 3, 'English', 'Medical Leave', 'Medical certificate required for absence', NULL, 'Medical Certificate Required', FALSE, FALSE, 'Within 3 days of return', 'Department Office'),
(7, 3, 'Tamil', 'மருத்துவ விடுப்பு', 'விடுப்புக்கு மருத்துவச் சான்றிதழ் தேவை', NULL, 'மருத்துவச் சான்றிதழ் அவசியம்', FALSE, FALSE, 'திரும்பிய 3 நாட்களுக்குள்', 'Department Office'),
(8, 4, 'English', 'Transfer Certificate', 'Students must complete department and office clearance before receiving TC', NULL, 'Clearance Required (7-10 days)', FALSE, FALSE, 'Immediate', 'Department and Admin Office'),
(9, 4, 'Tamil', 'மாற்றுச் சான்றிதழ்', 'TC பெற துறை மற்றும் அலுவலக clearance முடிக்க வேண்டும்', NULL, 'Clearance அவசியம் (7-10 நாட்கள்)', FALSE, FALSE, 'உடனடியாக', 'Department and Admin Office'),
(10, 6, 'English', 'Attendance Requirement', 'Minimum 75% attendance required to write exam', 75, 'Minimum 75%', FALSE, FALSE, NULL, 'Department and Admin Office'),
(11, 6, 'English', 'Condonation Fee', 'Condonation fee for 65-74% attendance', 250.00, 'Rs.250 condonation fee', TRUE, FALSE, '3 days before exam', 'Admin Office, Cash Counter'),
(12, 6, 'Tamil', 'Attendance Requirement', 'தேர்வு எழுத குறைந்தபட்சம் 75% attendance தேவை', 75, 'குறைந்தபட்சம் 75%', FALSE, FALSE, NULL, 'Department and Admin Office');

-- =========================
-- 4. ATTENDANCE CATEGORIES TABLE
-- =========================
CREATE TABLE attendance_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_code VARCHAR(5) NOT NULL,
    min_percent INT NOT NULL,
    max_percent INT NOT NULL,
    language VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    response TEXT NOT NULL,
    action_required VARCHAR(255) DEFAULT NULL,
    fee_applicable DECIMAL(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO attendance_categories (id, category_code, min_percent, max_percent, language, title, response, action_required, fee_applicable) VALUES
(1, 'A', 75, 100, 'English', 'Category A - Eligible', 'Eligible for exams without any restrictions', NULL, NULL),
(2, 'B', 65, 74, 'English', 'Category B - Condonation', 'Condonation fee Rs.250 must be paid before exam', 'Pay Rs.250 3 days before exam', 250.00),
(3, 'C', 50, 64, 'English', 'Category C - Not Allowed', 'Not allowed to write exam. Must repeat course.', 'Contact HOD for re-registration', NULL),
(4, 'D', 1, 49, 'English', 'Category D - Repeat', 'Must repeat entire course next semester', 'Visit Academic Office for re-admission', NULL),
(5, 'E', 0, 0, 'English', 'Category E - Rejoin', 'Must rejoin college in next academic year', 'Report to Principal Office', NULL),
(6, 'A', 75, 100, 'Tamil', 'வகை A - தகுதியுள்ள', 'எந்தவொரு கட்டுப்பாடும் இல்லாமல் தேர்வு எழுதலாம்', NULL, NULL),
(7, 'B', 65, 74, 'Tamil', 'வகை B - Condonation', 'தேர்வுக்கு முன் Rs.250 condonation fee செலுத்த வேண்டும்', 'தேர்வுக்கு 3 நாட்களுக்கு முன் Rs.250 செலுத்துங்கள்', 250.00),
(8, 'C', 50, 64, 'Tamil', 'வகை C - நிறுத்தப்பட்ட', 'தேர்வு எழுத அனுமதி இல்லை. பாடத்தை மீண்டும் படிக்க வேண்டும்.', 'மீண்டும் பதிவு செய்ய HOD-ஐ தொடர்புகொள்ளுங்கள்', NULL),
(9, 'D', 1, 49, 'Tamil', 'வகை D - மீண்டும் படிக்க', 'அடுத்த செமிஸ்டரில் முழு பாடத்தையும் மீண்டும் படிக்க வேண்டும்', 'Academic Office-ற்கு சென்று மீண்டும் சேர்க்கை செய்யுங்கள்', NULL),
(10, 'E', 0, 0, 'Tamil', 'வகை E - மீண்டும் சேர்க', 'அடுத்த கல்வி ஆண்டில் கல்லூரியில் மீண்டும் சேர்க வேண்டும்', 'Principal Office-க்கு செல்லுங்கள்', NULL);

-- =========================
-- 5. STUDENT REQUESTS TABLE
-- =========================
CREATE TABLE student_requests (
    id INT PRIMARY KEY,
    topic VARCHAR(255),
    year_of_discontinuation VARCHAR(50),
    reason VARCHAR(100),
    purpose TEXT,
    year_gap INT,
    amount DECIMAL(10,2),
    processing_time VARCHAR(50) DEFAULT NULL,
    office_location VARCHAR(255) DEFAULT NULL,
    notes TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO student_requests (id, topic, year_of_discontinuation, reason, purpose, year_gap, amount, processing_time, office_location, notes) VALUES
(1, 'Dropout/Discontinuation', 'Specify year', 'Academic/Personal/Financial/Health/Career/Other', 'Apply with reason proof', NULL, NULL, '7-10 working days', 'Admin Office, Ground Floor', 'All supporting documents required'),
(2, 'Medium of Instruction (MOI)', NULL, NULL, 'For job/higher studies', NULL, 1000.00, '3-4 working days', 'Admin Office', 'Charges applicable'),
(3, 'Duplicate Marksheet (1 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 1, 1000.00, '10-15 working days', 'Admin Office, Records Desk', '1 year gap'),
(4, 'Duplicate Marksheet (2 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 2, 2000.00, '10-15 working days', 'Admin Office, Records Desk', '2 year gap'),
(5, 'Duplicate Marksheet (3 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 3, 3000.00, '10-15 working days', 'Admin Office, Records Desk', '3 year gap'),
(6, 'Duplicate Marksheet (4 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 4, 4000.00, '10-15 working days', 'Admin Office, Records Desk', '4 year gap'),
(7, 'Duplicate Marksheet (5 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 5, 5000.00, '10-15 working days', 'Admin Office, Records Desk', '5 year gap'),
(8, 'Duplicate Marksheet (>5 Year Gap)', NULL, NULL, 'Not available - Direct University contact required', NULL, NULL, '4-6 weeks (University processing)', 'University Office', 'Service not available if gap > 5 years'),
(9, 'General Bonafide Certificate', NULL, NULL, 'Proof of being a student', NULL, NULL, '2-3 working days', 'Admin Office, Certificates Desk', 'Free service, No fees'),
(10, 'Course Bonafide Certificate', NULL, NULL, 'Course enrollment verification', NULL, NULL, '3-4 working days', 'Admin Office, Academics Desk', 'Free service'),
(11, 'Passport Bonafide Certificate', NULL, NULL, 'Required for passport process', NULL, 50.00, '2-3 working days', 'Admin Office, Certificates Desk', 'Fee: Rs.50'),
(12, 'Genuineness Certificate', NULL, NULL, 'Certificate verification', NULL, 500.00, '5-7 working days', 'Admin Office', 'For official verification'),
(13, 'Disability Student Exemption', NULL, NULL, 'Request for exemption from fees/attendance', NULL, NULL, '3-5 working days', 'Admin Office/Dean Office', 'Medical proof required'),
(14, 'Bonafide Without Fee Payment', NULL, NULL, 'Special case bonafide request', NULL, NULL, '3-5 working days (with approval)', 'Admin Office, Special Cases', 'Principal approval needed'),
(15, 'Fee Structure Certificate', NULL, NULL, 'Annual fee details', NULL, NULL, '2-3 working days', 'Finance Office, Block-B', 'Free service');

-- =========================
-- 6. ADMIN SERVICES TABLE
-- =========================
CREATE TABLE admin_services (
    id INT PRIMARY KEY,
    service_name VARCHAR(255),
    issued_by VARCHAR(100),
    purpose TEXT,
    requirements TEXT,
    fees DECIMAL(10,2),
    processing_time VARCHAR(50),
    office_location VARCHAR(255),
    notes TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO admin_services (id, service_name, issued_by, purpose, requirements, fees, processing_time, office_location, notes) VALUES
(1, 'Bonafide Certificate (General)', 'Admin Office', 'Proof of student status', 'Request form submission + Valid ID + Department/Union seals', 0.00, '2-3 working days', 'Admin Office, Main Building Ground Floor', 'Basic verification, No fees'),
(2, 'Fee Structure Certificate', 'Finance Office', 'Provides annual fee details', 'Request form submission + Fee payment receipt', 0.00, '2-3 working days', 'Finance Office, Block-B', 'Proof required'),
(3, 'Scholarship Form Application', 'Admin/Finance Office', 'Apply for scholarship', 'Approval from admin team + Income proof', 0.00, '5-7 working days', 'Finance Office, Block-B', 'Verification needed'),
(4, 'Course Bonafide', 'Admin Office', 'Course enrollment verification', 'Request submission + Valid ID', 0.00, '3-4 working days', 'Admin Office, Main Building Ground Floor', 'Free service'),
(5, 'Student Outpass', 'Admin Office', 'Permission to leave campus', 'Class Incharge approval + HOD permission', 0.00, '2-4 hours', 'Admin Office, Main Building Ground Floor', 'Maintain proper proof'),
(6, 'Passport Bonafide', 'Admin Office', 'Required for passport process', 'Request submission + Valid ID + Admission document copy', 50.00, '2-3 working days', 'Admin Office, Main Building Ground Floor', 'Fee: Rs.50'),
(7, 'Medium of Instruction (MOI)', 'Admin Office', 'Certificate stating language (English/Tamil)', 'Request submission + Valid ID', 1000.00, '3-4 working days', 'Admin Office, Main Building Ground Floor', 'Fee: Rs.1,000'),
(8, 'Attendance Certificate', 'Admin Office', 'Proof of previous semester attendance', 'Record verification + Valid ID', 0.00, '2-3 working days', 'Admin Office, Main Building Ground Floor', 'Free service'),
(9, 'First Graduation Certificate', 'Admin Office', 'Proof of first graduate status', 'Submit declaration if not available', 0.00, '3-4 working days', 'Admin Office, Main Building Ground Floor', 'Alternative proof accepted'),
(10, 'Menstrual Hygiene Product Service', 'College Facility', 'Sanitary napkin availability', 'Student ID + Request at designated counter', 0.00, 'Immediate', 'College Health Center, Block-C', 'Free service, Token system'),
(11, 'Subsidized Canteen Meals', 'Canteen Management', 'Affordable student meal service', 'Student ID + Token purchase', 10.00, 'Immediate', 'College Canteen, Behind Main Building', 'Budget: Rs.10/meal'),
(12, 'Complaint Registration Service', 'Union/Admin Office', 'Report issues or complaints', 'Detailed complaint letter', 0.00, 'Same day registration', 'Union Office/Admin Office', 'Action within 7 days'),
(13, 'Missing Items Report', 'Admin/Union Office', 'Report lost/found items on campus', 'Submit complaint + Detailed description', 0.00, 'Same day recording', 'Admin Office/Union Office', '30-day claim period'),
(14, 'Lost ID Card Reissue', 'Admin Office', 'Reissue ID card for lost/damaged cards', 'Application form + HOD approval + Declaration form', 250.00, '5-7 working days', 'Admin Office, Main Building Ground Floor', 'Fee: Rs.250'),
(15, 'Bonafide Without Fee (Special Cases)', 'Admin Office', 'Request bonafide without paying fees', 'Special permission required + Proof of hardship', 0.00, '3-5 working days', 'Admin Office, Main Building Ground Floor', 'Case-by-case approval'),
(16, 'Single Parent Student Support', 'Admin/Student Affairs', 'Support services for single parent students', 'Proof of single parent status', 0.00, '5-7 working days', 'Dean of Student Affairs Office', 'Staff approval needed'),
(17, 'Discontinuation and Resumption', 'Admin Office', 'Discontinue and resume studies', 'Request submission + Approved reason', 0.00, '5-7 working days', 'Admin Office, Main Building Ground Floor', 'No break allowed'),
(18, 'Physically Challenged Student Support', 'Admin Office/COE', 'Support for physically challenged students', 'Medical proof + COE permission + HOD letter', 0.00, '5-7 working days', 'Admin Office/Accessibility Office, Block-C', 'Free service, Special arrangements');

-- =========================
-- 7. DROPOUT REASONS TABLE
-- =========================
CREATE TABLE IF NOT EXISTS dropout_reasons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    reason_code VARCHAR(10) NOT NULL UNIQUE,
    reason_text VARCHAR(255) NOT NULL,
    reason_tamil VARCHAR(255) DEFAULT NULL,
    action_required VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO dropout_reasons (category, reason_code, reason_text, reason_tamil, action_required) VALUES
('Academic', 'AC01', 'Failed in exams repeatedly', 'தேர்வில் திரும்பவும் தோல்வி', 'Consult with Academic Advisor'),
('Academic', 'AC02', 'Unable to cope with studies', 'படிப்பை தொடர முடியவில்லை', 'Meet with Course Instructor'),
('Academic', 'AC03', 'Change of course or institution', 'வேறு படிப்பு / கல்லூரிக்கு மாறுதல்', 'Contact Admissions Office'),
('Academic', 'AC04', 'Transferred to another college', 'வேறு கல்லூரிக்கு இடமாற்றம்', 'Complete Admin formalities'),
('Personal', 'PE01', 'Marriage', 'திருமணம்', 'Provide marriage certificate'),
('Personal', 'PE02', 'Family responsibilities', 'குடும்ப பொறுப்புகள்', 'Submit affidavit'),
('Personal', 'PE03', 'Death of a parent or family member', 'குடும்பத்தினர் இறப்பு', 'Submit death certificate'),
('Personal', 'PE04', 'Relocation to another city or state', 'வேறு நகரம் / மாநிலத்திற்கு இடம் மாறுதல்', 'Update address with admin'),
('Financial', 'FI01', 'Unable to pay fees', 'கட்டணம் செலுத்த இயலவில்லை', 'Contact Finance Office'),
('Financial', 'FI02', 'Financial hardship or family income loss', 'நிதி சிரமம்', 'Submit income proof'),
('Financial', 'FI03', 'Need to work to support family', 'குடும்பத்தை ஆதரிக்க வேலைக்கு செல்வது', 'Discuss with Admin'),
('Health', 'HE01', 'Long-term medical illness', 'நீண்ட நாள் நோய்', 'Submit medical certificate'),
('Health', 'HE02', 'Mental health issues', 'மன நலப் பிரச்சினை', 'Contact Counseling Center'),
('Health', 'HE03', 'Physical disability or accident', 'உடல் ஊனம் / விபத்து', 'Register with Disability Services'),
('Career', 'CA01', 'Got a job', 'வேலை கிடைத்தது', 'Request TC'),
('Career', 'CA02', 'Pursuing competitive exams (UPSC/TNPSC)', 'போட்டித் தேர்வுகளுக்கு படிக்கிறேன்', 'Discuss options with admin'),
('Career', 'CA03', 'Started own business', 'சொந்த தொழில் தொடங்கியது', 'Submit business proof'),
('Career', 'CA04', 'Selected in armed forces or government service', 'அரசு / ராணுவ சேவையில் சேர்ந்தது', 'Request expedited TC'),
('Other', 'OT01', 'Personal reasons (undisclosed)', 'தனிப்பட்ட காரணம்', 'Discuss with HOD'),
('Other', 'OT02', 'Others', 'மற்றவை', 'Contact Admin Office');

-- =========================
-- VERIFICATION QUERIES
-- =========================

SELECT 'chatbot_intents table check' as verification, COUNT(*) as total_rows FROM chatbot_intents;
SELECT 'policies table check' as verification, COUNT(*) as total_rows FROM policies;
SELECT 'attendance_categories check' as verification, COUNT(*) as total_rows FROM attendance_categories;
SELECT 'student_requests check' as verification, COUNT(*) as total_rows FROM student_requests;
SELECT 'admin_services check' as verification, COUNT(*) as total_rows FROM admin_services;
SELECT 'dropout_reasons check' as verification, COUNT(*) as total_rows FROM dropout_reasons;

-- =========================
-- DISPLAY SAMPLE DATA
-- =========================

SELECT 'Chatbot Intents Sample' as title;
SELECT intent_id, intent_name, module_id, processing_time, fees, office_location FROM chatbot_intents LIMIT 5;

SELECT 'Policies Sample' as title;
SELECT policy_id, policy_title, value_numeric, due_date FROM policies LIMIT 5;

SELECT 'Attendance Categories Sample' as title;
SELECT category_code, min_percent, max_percent, action_required, fee_applicable FROM attendance_categories;
