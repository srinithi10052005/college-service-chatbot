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

-- =========================
-- 1. MODULES TABLE
-- =========================
DROP TABLE IF EXISTS modules;

CREATE TABLE modules (
    module_id INT AUTO_INCREMENT PRIMARY KEY,
    module_name VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO modules (module_name) VALUES
('General'),
('Fees'),
('Leave'),
('Certificate'),
('Admission');

-- =========================
-- 2. CHATBOT_INTENTS TABLE
-- =========================
DROP TABLE IF EXISTS chatbot_intents;

CREATE TABLE chatbot_intents (
    intent_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    language VARCHAR(20) NOT NULL DEFAULT 'English',
    keywords TEXT NOT NULL,
    user_question TEXT,
    response TEXT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =========================
-- 3. POLICIES TABLE
-- =========================
DROP TABLE IF EXISTS policies;

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

-- =========================
-- 4. GREETING INTENTS
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(1, 'English',
'hi hello hey good morning good afternoon good evening',
'Greeting',
'👋 Welcome to SDNB ASKNOVA. I am your service assistant. How can I help you today?'),

(1, 'Tamil',
'வணக்கம் ஹாய் ஹலோ காலை வணக்கம் மாலை வணக்கம்',
'வாழ்த்து',
'👋 எஸ்டிஎன்பி ASKNOVA-க்கு வரவேற்கிறோம். நான் உங்கள் சேவை உதவியாளர். உங்கள் கேள்விகளுக்கு உதவ தயாராக உள்ளேன்.');

-- =========================
-- 5. OUTPASS
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(3, 'English',
'outpass out pass gate pass leave campus outpass procedure permission',
'What is the outpass procedure?',
'Outpass Procedure:
1. Get permission from your Class Incharge.
2. Get approval from the HOD.
3. Then only you can leave the campus.'),

(3, 'Tamil',
'அவுட்பாஸ் outpass gate pass வெளியே போக அனுமதி அவுட்பாஸ் நடைமுறை',
'அவுட்பாஸ் எப்படிப் பெறுவது?',
'அவுட்பாஸ் பெறும் நடைமுறை:
1. முதலில் உங்கள் Class Incharge-ிடம் அனுமதி பெற வேண்டும்.
2. அதன் பிறகு HOD-ிடம் அனுமதி பெற வேண்டும்.
3. அனுமதி பெற்ற பிறகே கல்லூரி வளாகத்தை விட்டு வெளியே செல்லலாம்.');

-- =========================
-- 6. BONAFIDE CERTIFICATE
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(4, 'English',
'bonafide bonafide certificate student certificate bonafide apply bonafide procedure',
'How to apply for Bonafide Certificate?',
'Bonafide Certificate Procedure:
1. Go to the department and collect the bonafide form.
2. Fill in the required details.
3. Get seal from the department and union.
4. Submit the form to the admin office.'),

(4, 'Tamil',
'போனாபைடு bonafide bonafide certificate மாணவர் சான்று போனாபைடு நடைமுறை',
'போனாபைடு சான்றிதழ் எப்படிப் பெறுவது?',
'போனாபைடு சான்றிதழ் பெறும் நடைமுறை:
1. துறைக்கு சென்று Bonafide form வாங்க வேண்டும்.
2. தேவையான விவரங்களை நிரப்ப வேண்டும்.
3. துறை முத்திரை மற்றும் Union seal பெற வேண்டும்.
4. பின்னர் அதை Admin Office-க்கு சமர்ப்பிக்க வேண்டும்.');

-- =========================
-- 7. FEES DETAILS
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(2, 'English',
'fees fee payment fees details college fees installment',
'How to check fees details?',
'Students can check the fee details through the accounts office or the college portal.'),

(2, 'Tamil',
'கட்டணம் fees fee payment fees details கல்லூரி கட்டணம்',
'கட்டண விவரங்களை எப்படி தெரிந்து கொள்ளலாம்?',
'மாணவர்கள் கட்டண விவரங்களை Accounts Office அல்லது College Portal மூலம் தெரிந்து கொள்ளலாம்.');

-- =========================
-- 8. MISSING ID CARD
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(3, 'English',
'missing id card lost id card reissue id card id card procedure',
'What to do if ID card is missing?',
'Missing ID Card Procedure:
1. Inform your Class Incharge and HOD.
2. Give a letter to the department.
3. Submit the letter to the Admin Office.
4. Pay Rs.250 for reissue.
5. The new ID card will be issued within 1 week.
6. Until then, show the letter to the gate staff.'),

(3, 'Tamil',
'id card காணாமல் போனது missing id card lost id card id card இல்லாமல் id card நடைமுறை',
'ID Card காணாமல் போனால் என்ன செய்ய வேண்டும்?',
'ID Card காணாமல் போனால் செய்ய வேண்டியது:
1. முதலில் Class Incharge மற்றும் HOD-க்கு தகவல் சொல்ல வேண்டும்.
2. துறைக்கு ஒரு கடிதம் கொடுக்க வேண்டும்.
3. அந்த கடிதத்தை Admin Office-க்கு சமர்ப்பிக்க வேண்டும்.
4. ரூ.250 கட்டணம் செலுத்த வேண்டும்.
5. புதிய ID Card ஒரு வாரத்தில் வழங்கப்படும்.
6. அந்த ஒரு வாரம் Gate Staff-க்கு அந்த கடிதத்தை காட்ட வேண்டும்.');

-- =========================
-- 9. TC - PASS OUT
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(4, 'English',
'tc transfer certificate passout pass out course completed tc procedure',
'How to get TC after course completion?',
'Transfer Certificate Procedure for Pass Out Students:
1. Go to your department.
2. Submit the application.
3. Get HOD signature.
4. Complete office clearance.
5. Collect the Transfer Certificate.'),

(4, 'Tamil',
'படிப்பு முடிந்த பிறகு tc passout tc transfer certificate',
'படிப்பு முடிந்த பிறகு TC எப்படி பெறுவது?',
'படிப்பு முடித்த மாணவர்களுக்கான TC நடைமுறை:
1. துறைக்கு சென்று விண்ணப்பம் எழுத வேண்டும்.
2. HOD கையொப்பம் பெற வேண்டும்.
3. Office-ல் clearance முடிக்க வேண்டும்.
4. அதன் பிறகு Transfer Certificate வழங்கப்படும்.');

-- =========================
-- 10. TC - DISCONTINUED
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(4, 'English',
'tc discontinue discontinued transfer certificate left course dropout tc',
'How to get TC if course is discontinued?',
'Transfer Certificate Procedure for Discontinued Students:
1. Inform the department.
2. Submit a written application for TC.
3. Complete the required clearance.
4. Collect the Transfer Certificate from the office.'),

(4, 'Tamil',
'படிப்பை நிறுத்தினால் tc discontinued tc transfer certificate',
'படிப்பை நிறுத்தினால் TC எப்படி பெறுவது?',
'படிப்பை நிறுத்திய மாணவர்களுக்கான TC நடைமுறை:
1. துறைக்கு தகவல் தெரிவிக்க வேண்டும்.
2. TC பெற விண்ணப்பம் எழுத வேண்டும்.
3. தேவையான clearance முடிக்க வேண்டும்.
4. Admin Office மூலம் Transfer Certificate பெறலாம்.');

-- =========================
-- 11. LONG ABSENTEES
-- =========================
INSERT INTO chatbot_intents (module_id, language, keywords, user_question, response) VALUES
(3, 'English',
'long absence long absentees absent many days attendance shortage',
'What is the procedure for long absentees?',
'Students who are absent for a long period must inform the department and contact the admin office for further guidance.'),

(3, 'Tamil',
'நீண்ட நாட்கள் வராத மாணவர்கள் long absence long absentees attendance shortage',
'நீண்ட நாட்கள் வராத மாணவர்கள் என்ன செய்ய வேண்டும்?',
'நீண்ட நாட்கள் வராத மாணவர்கள்:
1. Class Incharge மற்றும் HOD-க்கு தகவல் தெரிவிக்க வேண்டும்.
2. வராததற்கான காரணத்தை விளக்க வேண்டும்.
3. தேவையானால் Admin Office-ஐ தொடர்பு கொள்ள வேண்டும்.');

-- =========================
-- 12. SAMPLE POLICIES
-- =========================
INSERT INTO policies
(module_id, language, policy_title, policy_description, value_numeric, value_text, fine_applicable, installment_allowed)
VALUES
(2, 'English', 'Late Fee Payment', 'Fine may be applicable after the fee due date.', NULL, 'Fine Applicable', TRUE, TRUE),
(2, 'Tamil', 'தாமத கட்டணம்', 'கட்டணத்தின் கடைசி தேதிக்குப் பிறகு அபராதம் விதிக்கப்படலாம்.', NULL, 'அபராதம் பொருந்தும்', TRUE, TRUE),

(3, 'English', 'Medical Leave', 'Medical certificate must be submitted to the department.', NULL, 'Medical Certificate Required', FALSE, FALSE),
(3, 'Tamil', 'மருத்துவ விடுப்பு', 'மருத்துவச் சான்றிதழ் துறைக்கு சமர்ப்பிக்க வேண்டும்.', NULL, 'மருத்துவச் சான்றிதழ் அவசியம்', FALSE, FALSE),

(4, 'English', 'Transfer Certificate', 'Students must complete department and office clearance before receiving TC.', NULL, 'Clearance Required', FALSE, FALSE),
(4, 'Tamil', 'மாற்றுச் சான்றிதழ்', 'TC பெற துறை மற்றும் அலுவலக clearance முடிக்க வேண்டும்.', NULL, 'Clearance அவசியம்', FALSE, FALSE);

