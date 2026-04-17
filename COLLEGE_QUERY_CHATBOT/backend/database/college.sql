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
(1, '🏠 General'),
(2, '💰 Fees'),
(3, '📋 Leave'),
(4, '📜 Certificate'),
(5, '🎓 Admission'),
(6, '📅 Attendance');

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

(1, 1, 'English', 'greeting',
'hi, hello, hey, good morning, good afternoon, good evening',
'👋 Welcome to  ASKNOVA! 🎓\nI am your smart service assistant. How can I help you today? 😊\nType your query and I will guide you right away! ✅',
NULL, NULL, NULL),

(2, 1, 'Tamil', 'greeting',
'வணக்கம், ஹாய், ஹலோ, காலை வணக்கம், மாலை வணக்கம்',
'👋 ASKNOVA-க்கு வரவேற்கிறோம்! 🎓\nநான் உங்கள் சேவை உதவியாளர். உங்கள் கேள்விகளுக்கு உதவ தயாராக உள்ளேன். 😊\nதங்கள் கேள்வியை தட்டச்சு செய்யுங்கள்! ✅',
NULL, NULL, NULL),

(3, 3, 'English', 'outpass',
'outpass, out pass, how to get outpass, outpass procedure, gate pass, leave permission, campus leave, permission to leave, permission to go outside, campus exit permission, go outside permission, exit campus',
'🚪 Outpass Procedure ⏱️ Processing Time: 2–4 Hours\n\n📝 1: Visit your Class Incharge in your department.\n✍️ 2: Get written permission from HOD \n🏛️ 3: Visit Admin Office (Main Building(IT BLOCK), Ground Floor) with approval letter.\n📒  4: Enter your details in outpass register with OUT and IN times.\n🔐  5: Show outpass at main gate to security.\n🔄  6: Return outpass upon returning to campus.\n\n📞 Contact: Admin Office — Evening Block \n🕐 Timings: Mon–Fri, 9:00 AM – 4:30 PM',
'2-4 hours', NULL, 'Admin Office, Main Building(IT BOCK), Ground Floor'),

(4, 3, 'Tamil', 'outpass',
'அவுட்பாஸ், வெளியே செல்ல அனுமதி, outpass procedure',
'🚪 அவுட்பாஸ் நடைமுறை — SDNB Vaishnav College\n⏱️ செயல்படுத்தும் நேரம்: 2–4 மணிநேரம்\n\n📝 1: உங்கள் Class Incharge-ஐ சந்தியுங்கள்.\n✍️ படி 2: HOD-ஐ தொடர்புகொண்டு அனுமதிப்பத்திரம் பெறுங்கள் .\n🏛️  3: அனுமதிப்பத்திரத்துடன் Admin Office-ற்குச் செல்லுங்கள் (முதன்மை கட்டடம், தாழ்வாரம்).\n📒  4: அவுட்பாஸ் பதிவேட்டில் நுழைந்த மற்றும் வெளியேறிய நேரம் பதிவு செய்யுங்கள்.\n🔐 5: பாதுகாப்பாளரிடம் முதன்மை வாயிலில் அவுட்பாஸ் காட்டுங்கள்.\n🔄 6: Admin Office-ற்கு அவுட்பாஸ் திருப்பி அளியுங்கள்.\n\n📞 தொடர்பு: Admin Office — நீட்சி 105\n🕐 நேரம்: திங்கட்கிழமை–வெள்ளிக்கிழமை, 9:00 AM – 4:30 PM',
'2-4 மணிநேரம்', NULL, 'Admin Office, முதன்மை கட்டடம், தாழ்வாரம்'),

(5, 4, 'English', 'bonafide',
'bonafide',
'📜 Bonafide Certificates — SDNB Vaishnav College\n\n1️⃣ General Bonafide Certificate — 🆓 FREE | ⏱️ 2–3 days\n2️⃣ Course Bonafide — 🆓 FREE | ⏱️ 3–4 days\n3️⃣ Passport Bonafide — 💰 Rs.50 | ⏱️ 2–3 days\n4️⃣ Bonafide Without Fee — 🆓 FREE (Special Permission) | For genuine financial hardship\n\n💬 Please type: general bonafide, course bonafide, passport bonafide, or bonafide without fee\n\n📍 Location: Admin Office, Main Building(IT BLOCK), Ground Floor\n🕐 Timings: Mon–Fri, 9:00 AM – 4:30 PM\n📞 Contact: Evening Office',
NULL, NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(6, 4, 'Tamil', 'bonafide',
'போனாபைடு, போனாபைடு சான்றிதழ்',
'📜 Bonafide Certificates — SDNB Vaishnav College\n\n1️⃣ General Bonafide — 🆓 இலவசம் | ⏱️ 2–3 நாட்கள்\n2️⃣ Course Bonafide — 🆓 இலவசம் | ⏱️ 3–4 நாட்கள்\n3️⃣ Passport Bonafide — 💰 Rs.50 | ⏱️ 2–3 நாட்கள்\n4️⃣ Fee இல்லாமல் Bonafide — 🆓 இலவசம் (சிறப்பு அனுமதி) | நிதி சிரமத்தில் உள்ளவர்களுக்கு\n\n💬 Type செய்யவும்: general bonafide, course bonafide, passport bonafide, bonafide without fee\n\n📍 இடம்: Admin Office, முதன்மை கட்டடம், தாழ்வாரம்\n🕐 நேரம்: திங்கட்கிழமை–வெள்ளிக்கிழமை, 9:00 AM – 4:30 PM\n📞 தொடர்பு: நீட்சி 105',
NULL, NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(7, 4, 'English', 'tc_procedure',
'tc, tc procedure, transfer certificate, how to get tc, tc process, certificate process, tc for passout, passout tc',
'🎓 Transfer Certificate — (Pass Out Students)\n⏱️ Processing: 7–10 Working Days\n\n📝  1: Visit Department with application form.\n✍️ 2: Get HOD signature and stamp.\n📚  3: Library clearance (return all books).\n🏠  4: Hostel clearance (if resident).\n🏛️ 5: Complete office clearance at Admin Office with receipts.\n📂  6: Submit final documents to Admin Office.\n🏅  7: Collect TC Certificate after 7–10 days.\n\n📍From res[ective  Department  | Library (GB Block) | Hostel (Behind Gate) | Admin Office (Main Building(IT BLOCK), GF)\n📞 Contact: Admin Office — Evening Block\n🕐 Mon–Fri, 9:00 AM – 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(8, 4, 'Tamil', 'tc_procedure',
'tc, transfer certificate, tc நடைமுறை',
'🎓 Transfer Certificate — SDNB Vaishnav College (பட்டம் பெற்ற மாணவர்கள்)\n⏱️ செயல்படுத்தும் நேரம்: 7–10 வேலை நாட்கள்\n\n📝 படி 1: விண்ணப்பப் படிவத்துடன் துறை அலுவலகத்திற்குச் செல்லுங்கள்.\n✍️ படி 2: HOD கையொப்பம் மற்றும் முத்திரை பெறுங்கள்.\n📚 படி 3: நூலகம் (புத்தகங்களை திருப்பி அளியுங்கள்).\n🏠 படி 4: விடுதி சரியாக்கல் (பொருந்தினால்).\n🏛️ படி 5: Admin Office-ற்கு ரசீதுகளுடன் சரியாக்கல் முடிக்கவும்.\n📂 படி 6: Admin Office-ற்கு இறுதி ஆவணங்களை சமர்ப்பிக்கவும்.\n🏅 படி 7: 7–10 வேலை நாட்களுக்குப் பிறகு TC சான்றிதழ் சேகரிக்கவும்.\n\n📞 தொடர்பு: Admin Office — நீட்சி 105\n🕐 நேரம்: திங்கட்கிழமை–வெள்ளிக்கிழமை, 9:00 AM – 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(9, 3, 'English', 'missing_id',
'missing id, id card lost, lost id, lost id card, id lost, duplicate id, duplicate id card, id card procedure, missing id procedure',
'🪪 Missing ID Card Reissue \n⏱️ Processing: 5–7 Working Days | 💰 Fee: Rs.250\n\n⚠️ 1: Inform Class Incharge within respective shift timing.\n✍️ 2: Inform HOD in writin.\n🏛️  3: Visit Admin Office (Main Building, GF) with:\n   📄 Lost ID Declaration Form\n   📩 Class Incharge notification\n   📜 HOD Approval Letter\n💵 4: Pay Rs.250 at Adimin Office.\n🪪 5: Get provisional ID receipt (valid 15 days).\n🔐 6: Report to Campus Security with receipt.\n✅  7: Collect new ID after 5–7 days.\n\n📞 Contact: Admin Office — Evening Office \n🕐 Mon–Fri, 9:00 AM – 4:30 PM\n⚠️ Note: Without ID, entry may be restricted at gates.',
'5-7 working days', 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(10, 3, 'Tamil', 'missing_id',
'மிஸ்ஸிங் ஐடி, அடையாள அட்டை தொலைந்தது, id card காணவில்லை',
'🪪 ID அட்டை மீண்டும் வெளியீடு — SDNB Vaishnav College\n⏱️ 5–7 வேலை நாட்கள் | 💰 கட்டணம்: Rs.250\n\n⚠️ படி 1: 24 மணிநேரத்திற்குள் Class Incharge-க்கு தகவல் சொல்லுங்கள்.\n✍️ படி 2: HOD-க்கு எழுத்துப்பூர்வ தகவல் சொல்லுங்கள்.\n🏛️ படி 3: Admin Office-ற்குச் செல்லுங்கள்:\n   📄 Lost ID பிரகடன படிவம்\n   📩 Class Incharge அறிவிப்பு\n   📜 HOD அனுமதி கடிதம்\n💵 படி 4: Cash Counter-ல் Rs.250 செலுத்துங்கள்.\n🪪 படி 5: 15 நாட்கள் செல்லுபடியாகும் தற்காலிக ID ரசீது பெறுங்கள்.\n🔐 படி 6: Campus Security-ற்கு ரசீதுடன் புகாரளியுங்கள்.\n✅ படி 7: 5–7 வேலை நாட்களுக்குப் பிறகு புதிய ID சேகரிக்கவும்.\n\n📞 தொடர்பு: நீட்சி 105\n🕐 நேரம்: திங்கட்கிழமை–வெள்ளிக்கிழமை, 9:00 AM – 4:30 PM\n⚠️ குறிப்பு: ID இல்லாமல் வாயிலில் நுழைய தடுக்கப்படலாம்.',
'5-7 working days', 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(11, 6, 'English', 'exam_eligibility',
'write exam, exam procedure, exam eligibility, eligible to write exam, can i write exam, how to write exam, can i attend exam with low attendance',
'📊 Exam Eligibility Based on Attendance \n\n✅ Category A (75% or more): ELIGIBLE — Write exam without restrictions.\n⚠️ Category B (65–74%): ELIGIBLE with Condonation — Pay 💰 Rs.250 fee 3 days before exam.\n❌ Category C (50–64%): NOT ELIGIBLE — Repeat course next semester. Contact HOD for re-registration.\n🚫 Category D (Less than 50%): NOT ELIGIBLE — Repeat entire course. Complete re-registration required.\n\n💵 Condonation Payment: Admin Office, Cash Counter\n📞 Contact: Admin Office — Evening Block \n🕐 Mon–Fri, 9:00 AM – 4:30 PM\n💡 Tip: Maintain 75%+ attendance to avoid complications! 😊',
NULL, 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(12, 6, 'Tamil', 'exam_eligibility',
'exam எழுத, exam eligibility, தேர்வு எழுதலாமா',
'📊 Attendance-ல் அடிப்படையாக தேர்வு தகுதி — SDNB Vaishnav College\n\n✅ Category A (75% அல்லது அதற்கு மேல்): தகுதி உள்ளது — கட்டுப்பாடு இல்லாமல் தேர்வு எழுதலாம்.\n⚠️ Category B (65–74%): Condonation உடன் தகுதி — 💰 Rs.250 fee தேர்வுக்கு 3 நாட்களுக்கு முன் செலுத்துங்கள்.\n❌ Category C (50–64%): தகுதி இல்லை — அடுத்த செமிஸ்டரில் மீண்டும் படிக்கவும்.\n🚫 Category D (50% குறைவு): தகுதி இல்லை — முழு பாடம் மீண்டும் படிக்கவும்.\n\n💵 Condonation செலுத்தும் இடம்: Admin Office, Cash Counter\n📞 தொடர்பு: நீட்சி 105\n🕐 நேரம்: திங்கட்கிழமை–வெள்ளிக்கிழமை, 9:00 AM – 4:30 PM\n💡 குறிப்பு: 75% attendance வைத்திருங்கள்! 😊',
NULL, 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(13, 4, 'English', 'tc_discontinued',
'tc discontinued, tc for discontinued, discontinued tc, dropout tc, left course tc, drop out',
'🎓 Transfer Certificate  (Discontinued/Dropout Students)\n⏱️ Processing: 7–10 Working Days\n\n📝 1: Contact HOD with discontinuation letter.\n📋 2: Collect TC Application Form from Department Office.\n✍️ 3: Get approval from Class Incharge and HOD (Signature & Stamp).\n📚 4: Get Library clearance (return all books).\n🏠 5: Get Hostel clearance if resident.\n🏛️  6: Visit Admin Office with all documents:\n   📄 TC Form | 📜 HOD Letter | 📚 Library Clearance | 🏠 Hostel Clearance | 🗂️ Admission Document\n💵 7: Pay pending fees if any.\n🏅 8: Collect TC after 7–10 days.\n\n⚠️ Note: Submit reason for discontinuation.\n📞 Contact: Admin Office — Evening Office\n🕐 Mon–Fri, 9:00 AM – 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(14, 4, 'Tamil', 'tc_discontinued',
'படிப்பை நிறுத்தினால் tc, discontinued tc, dropout tc, transfer certificate',
'🎓 Transfer Certificate — SDNB Vaishnav College (நிறுத்திய மாணவர்கள்)\n⏱️ 7–10 வேலை நாட்கள்\n\n📝 படி 1: நிறுத்தும் கடிதத்துடன் HOD-ஐ தொடர்புகொள்ளுங்கள்.\n📋 படி 2: துறை அலுவலகத்திலிருந்து TC விண்ணப்பப் படிவம் சேகரிக்கவும்.\n✍️ படி 3: Class Incharge மற்றும் HOD இலிருந்து அனுமதி பெறுங்கள்.\n📚 படி 4: நூலகத்திலிருந்து சரியாக்கல் (புத்தகங்களை திருப்பி).\n🏠 படி 5: விடுதி வாசியாக இருந்தால் விடுதி சரியாக்கல்.\n🏛️ படி 6: Admin Office-ற்கு ஆவணங்களுடன் செல்லுங்கள்.\n💵 படி 7: நிலுவைக் கட்டணம் இருந்தால் செலுத்துங்கள்.\n🏅 படி 8: 7–10 நாட்களுக்குப் பிறகு TC சேகரிக்கவும்.\n\n📞 தொடர்பு: நீட்சி 105\n🕐 நேரம்: திங்கட்கிழமை–வெள்ளிக்கிழமை, 9:00 AM – 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(15, 4, 'English', 'bonafide_general',
'general bonafide certificate, general bonafide, student bonafide',
'📄 General Bonafide Certificate \n🆓 Fee: FREE | ⏱️ Processing: 2–3 Working Days\n\n🎯 Purpose: Proof of student status — required for scholarships, educational loans, visa applications.\n\n📝1: Visit Admin Office (Main Building (IT BLOCK), Ground Floor).\n📋 2: Collect General Bonafide Request Form.\n✍️ 3: Fill with registration number, name, department, year.\n🏫  4: Visit Department for Class Incharge signature and seal.\n🤝 5: Visit College Union for signature.\n🏛️ 6: Return to Admin Office with completed form.\n✅  7: Collect after 2–3 days.\n\n🗂️ Required: Valid ID Card | Filled Form | Department & Union seals\n📞 Contact: Admin Office — Extension 105\n🕐 Mon–Fri, 9:00 AM – 4:30 PM',
'2-3 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(16, 4, 'English', 'course_bonafide',
'course bonafide',
'📄 Course Bonafide Certificate\n🆓 Fee: FREE | ⏱️ Processing: 3–4 Working Days\n\n🎯 Purpose: Verification of current course enrollment — required for semester admissions.\n\n📝1: Visit Admin Office (Main Building(IT BLOCK), Ground Floor).\n📋2: Fill Course Bonafide Request Form.\n✍️3: Provide semester details, registration number, course code and name.\n🔍 4: Admin staff verify enrollment in system.\n✅ 5: Collect after 3–4 days.\n\n🗂️ Required: Valid ID Card | Filled Request Form\n📞 Contact: Admin Office — Evening Office\n🕐 Mon–Fri, 9:00 AM – 4:30 PM',
'3-4 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(17, 4, 'English', 'passport_bonafide',
'passport bonafide',
'🛂 Passport Bonafide Certificate \n💰 Fee: Rs.50 | ⏱️ Processing: 2–3 Working Days\n\n🎯 Purpose: Mandatory for passport applications — accepted by Ministry of External Affairs.\n\n📝1: Visit Admin Office (Main Building(IT BLOCK), Ground Floor).\n📋 2: Collect Passport Bonafide Request Form.\n✍️ 3: Fill with full name, date of birth, registration number, current semester.\n📎4: Attach ID copy and Admission Document copy.\n💵 5: Pay Rs.50 at Adimin Office.\n📤6: Submit to Certificates Desk.\n✅ 7: Collect after 2–3 days.\n\n⚠️ Important: Name must match government ID. Certificate validity: 1 year.\n📞 Contact: Admin Office — Evening Block \n🕐 Mon–Fri, 9:00 AM – 4:30 PM',
'2-3 working days', 50.00, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(18, 4, 'English', 'bonafide_without_fee',
'bonafide without fee, bonafide without fee payment, no fee bonafide',
'📄 Bonafide Without Fee Payment \n🆓 Fee: FREE (Special Permission Only) | ⏱️ Processing: 3–5 Working Days\n\n✅ Eligibility: Proven financial hardship | Orphaned | Single parent family | Scholarship recipient | Exceptional cases\n\n🗂️ Required Documents:\n   📝 Request letter explaining waiver reason\n   💼 Financial proof (BPL Certificate or income proof)\n   🪪 Valid ID Card | 🗂️ Admission Document\n\n🔄 Process Flow:\n   📤 Submit at Admin Office\n   👩‍🏫 Class Incharge verification\n   🧑‍💼 HOD approval\n   🎓 Dean of Student Affairs\n   🏅 Final approval from Principal\n\n⏱️ Verification: 2–3 days | Approval: 1–2 days | Issue: 1 day\n⚠️ Important: Approval is NOT automatic. Decided case-by-case.\n📞 Contact: Admin Office - Evening Block \n🕐 Mon–Fri, 9:00 AM – 4:30 PM',
'3-5 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(21, 4, 'English', 'marksheet_lost',
'marksheet lost, lost marksheet, my marksheet is lost, certificate lost, duplicate marksheet',
 '📄 Duplicate Marksheet/Certificate \n⏱️ Processing: 10–15 Working Days\n\n💰 Fee Structure (Based on Year Gap):\n   1 year = Rs.1,000 | 2 years = Rs.2,000 | 3 years = Rs.3,000\n   4 years = Rs.4,000 | 5 years = Rs.5,000 | After 5 years = 🏫 University Processing (4–6 weeks)\n\n📝1: Visit Admin Office (Main Building (IT BLOCK), Ground Floor).\n📋 2: Collect Duplicate Certificate Request Form.\n✍️ 3: Fill with semester/exam year, subject codes, exam registration number.\n📎4: Provide ID copy, Admission Document copy, Police FIR (if lost/stolen).\n💵 5: Pay fee at Cash Counter (Rs.100 Processing fee + Duplication fee).\n📤6: Submit form with receipts.\n🔍7: Admin verifies with University records.\n✅ 8: Duplicate printed and issued.\n\n⚠️ Important: Official government certification. Not available if gap exceeds 5 years.\n📞 Contact: Admin Office — Evening Block \n🕐 Mon–Fri, 9:00 AM – 4:30 PM',
'10-15 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(22, 4, 'Tamil', 'marksheet_lost',
'மார்க்ஷீட் தொலைந்தது, marksheet lost, certificate lost, duplicate marksheet',
'📄 Duplicate மார்க்ஷீட்/சான்றிதழ் — SDNB Vaishnav College\n⏱️ 10–15 வேலை நாட்கள்\n\n💰 கட்டணம் (ஆண்டு இடைவெளிக்கு):\n   1 ஆண்டு = Rs.1,000 | 2 = Rs.2,000 | 3 = Rs.3,000\n   4 = Rs.4,000 | 5 = Rs.5,000 | 5+ = 🏫 பல்கலைக்கழகம் (4–6 வாரங்கள்)\n\n📝 படி 1: Admin Office-ற்குச் செல்லுங்கள் (முதன்மை கட்டடம், தாழ்வாரம்).\n📋 படி 2: Duplicate சான்றிதழ் கோரிக்கைப் படிவம் சேகரிக்கவும்.\n✍️ படி 3: செமிஸ்டர்/தேர்வு ஆண்டு, பாடப் குறியீடுகள், தேர்வு பதிவு எண் நிரப்பவும்.\n📎 படி 4: ID நகல், சேர்க்கை நகல், போலீஸ் FIR (தேவையில்) வழங்குங்கள்.\n💵 படி 5: Cash Counter-ல் கட்டணம் செலுத்துங்கள் (Rs.100 செயல்படுத்தும் + duplicate fee).\n📤 படி 6: ரசீதுகளுடன் சமர்ப்பிக்கவும்.\n🔍 படி 7: Admin பல்கலைக்கழக பதிவுகளுடன் சரிபார்க்கும்.\n✅ படி 8: Duplicate அச்சிட வெளியீடு.\n\n📞 தொடர்பு: நீட்சி 105\n🕐 நேரம்: திங்கட்கிழமை–வெள்ளிக்கிழமை, 9:00 AM – 4:30 PM',
'10-15 working days', NULL, 'Admin Office, Main Building, Ground Floor');

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
(1, 2, 'English', '💰 Semester Fee', '📋 Annual fee per semester at SDNB Vaishnav College', 'refer college website for update ', '📅 Due on registration', FALSE, TRUE, 'Before semester starts', '🏛️ Finance Office ( Admin Office)'),
(2, 2, 'English', '⚠️ Late Fee', '🚨 Fine applicable after due date (Rs.500 per day)', 500.00, '❌ Fine Applicable', TRUE, FALSE, '7 days after due date', '🏛️ Finance Office  ( Admin Office)'),
(3, 2, 'English', '🏠 Hostel Fee', '🛏️ Annual hostel charges for residents', 30000.00, '📅 Payable once a year', FALSE, FALSE, 'Before hostel registration', '🏠 Hostel Office'),
(4, 2, 'Tamil', '💰 செமிஸ்டர் கட்டணம்', '📋 SDNB Vaishnav College-ல் ஒரு செமிஸ்டருக்கு ஆண்டு கட்டணம்', 50000.00, '📅 பதிவுக்கு முன் செலுத்த வேண்டும்', FALSE, TRUE, 'செமிஸ்டர் தொடங்குவதற்கு முன்', '🏛️ Finance Office, Block-B'),
(5, 2, 'Tamil', '⚠️ தாமத கட்டணம்', '🚨 கட்டணத்தின் கடைசி தேதிக்குப் பிறகு அபராதம் (Rs.500 நாளொன்றுக்கு)', 500.00, '❌ அபராதம் பொருந்தும்', TRUE, FALSE, 'கடைசி தேதிக்கு 7 நாட்களுக்குப் பிறகு', '🏛️ Finance Office'),
(6, 3, 'English', '🏥 Medical Leave', '📋 Medical certificate required for absence', NULL, '📄 Medical Certificate Required', FALSE, FALSE, 'Within 3 days of return', '🏫 Department'),
(7, 3, 'Tamil', '🏥 மருத்துவ விடுப்பு', '📋 விடுப்புக்கு மருத்துவச் சான்றிதழ் தேவை', NULL, '📄 மருத்துவச் சான்றிதழ் அவசியம்', FALSE, FALSE, 'திரும்பிய 3 நாட்களுக்குள்', '🏫 Department Office'),
(8, 4, 'English', '🎓 Transfer Certificate', '📋 Students must complete department and office clearance before receiving TC', NULL, '✅ Clearance Required (7–10 days)', FALSE, FALSE, 'Immediate', '🏛️ Department and Admin Office'),
(9, 4, 'Tamil', '🎓 மாற்றுச் சான்றிதழ்', '📋 TC பெற துறை மற்றும் அலுவலக clearance முடிக்க வேண்டும்', NULL, '✅ Clearance அவசியம் (7–10 நாட்கள்)', FALSE, FALSE, 'உடனடியாக', '🏛️ Department and Admin Office'),
(10, 6, 'English', '📅 Attendance Requirement', '⚠️ Minimum 75% attendance required to write exam at SDNB Vaishnav College', 75, '✅ Minimum 75%', FALSE, FALSE, NULL, '🏛️ Department and Admin Office'),
(11, 6, 'English', '💰 Condonation Fee', '📋 Condonation fee for 65–74% attendance', 250.00, '💵 Rs.250 condonation fee', TRUE, FALSE, '3 days before exam', '🏛️ Admin Office '),
(12, 6, 'Tamil', '📅 Attendance Requirement', '⚠️ தேர்வு எழுத குறைந்தபட்சம் 75% attendance தேவை', 75, '✅ குறைந்தபட்சம் 75%', FALSE, FALSE, NULL, '🏛️ Department and Admin Office');

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
(1, 'A', 75, 100, 'English', '✅ Category A — Eligible', '🎉 Great job! You are eligible for exams without any restrictions.', NULL, NULL),
(2, 'B', 65, 74, 'English', '⚠️ Category B — Condonation Required', '💰 Condonation fee Rs.250 must be paid before exam. Don\'t miss the deadline!', '💵 Pay Rs.250 at least 3 days before exam', 250.00),
(3, 'C', 50, 64, 'English', '❌ Category C — Not Allowed', '🚫 Not allowed to write exam. You must repeat the course next semester.', '📋 Contact HOD for re-registration', NULL),
(4, 'D', 1, 49, 'English', '🚫 Category D — Repeat Course', '⛔ You must repeat the entire course next semester.', '🏫 Visit Academic Office for re-admission', NULL),
(5, 'E', 0, 0, 'English', '🔄 Category E — Rejoin', '📢 You must rejoin SDNB Vaishnav College in the next academic year.', '🏛️ Report to Principal / Director ', NULL),
(6, 'A', 75, 100, 'Tamil', '✅ வகை A — தகுதியுள்ள', '🎉 சிறப்பு! எந்தவொரு கட்டுப்பாடும் இல்லாமல் தேர்வு எழுதலாம்.', NULL, NULL),
(7, 'B', 65, 74, 'Tamil', '⚠️ வகை B — Condonation தேவை', '💰 தேர்வுக்கு முன் Rs.250 condonation fee செலுத்த வேண்டும்!', '💵 தேர்வுக்கு 3 நாட்களுக்கு முன் Rs.250 செலுத்துங்கள்', 250.00),
(8, 'C', 50, 64, 'Tamil', '❌ வகை C — அனுமதி இல்லை', '🚫 தேர்வு எழுத அனுமதி இல்லை. பாடத்தை மீண்டும் படிக்க வேண்டும்.', '📋 மீண்டும் பதிவு செய்ய HOD-ஐ தொடர்புகொள்ளுங்கள்', NULL),
(9, 'D', 1, 49, 'Tamil', '🚫 வகை D — மீண்டும் படிக்க', '⛔ அடுத்த செமிஸ்டரில் முழு பாடத்தையும் மீண்டும் படிக்க வேண்டும்.', '🏫 Academic Office-ற்கு சென்று மீண்டும் சேர்க்கை செய்யுங்கள்', NULL),
(10, 'E', 0, 0, 'Tamil', '🔄 வகை E — மீண்டும் சேர்க', '📢 அடுத்த கல்வி ஆண்டில் SDNB Vaishnav College-ல் மீண்டும் சேர்க வேண்டும்.', '🏛️ Principal Office-க்கு செல்லுங்கள்', NULL);

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
(1, '🚪 Dropout/Discontinuation', 'Specify year', 'Academic/Personal/Financial/Health/Career/Other', '📋 Apply with reason proof', NULL, NULL, '7-10 working days', '🏛️ Admin Office, Ground Floor', '📎 All supporting documents required'),
(2, '📜 Medium of Instruction (MOI)', NULL, NULL, '🎓 For job/higher studies', NULL, 1000.00, '3-4 working days', '🏛️ Admin Office', '💰 Charges applicable: Rs.1,000'),
(3, '📄 Duplicate Marksheet (1 Year Gap)', NULL, NULL, '📋 Request for duplicate certificates', 1, 1000.00, '10-15 working days', '🏛️ Admin Office, Records Desk', '💰 1 year gap — Rs.1,000'),
(4, '📄 Duplicate Marksheet (2 Year Gap)', NULL, NULL, '📋 Request for duplicate certificates', 2, 2000.00, '10-15 working days', '🏛️ Admin Office, Records Desk', '💰 2 year gap — Rs.2,000'),
(5, '📄 Duplicate Marksheet (3 Year Gap)', NULL, NULL, '📋 Request for duplicate certificates', 3, 3000.00, '10-15 working days', '🏛️ Admin Office, Records Desk', '💰 3 year gap — Rs.3,000'),
(6, '📄 Duplicate Marksheet (4 Year Gap)', NULL, NULL, '📋 Request for duplicate certificates', 4, 4000.00, '10-15 working days', '🏛️ Admin Office, Records Desk', '💰 4 year gap — Rs.4,000'),
(7, '📄 Duplicate Marksheet (5 Year Gap)', NULL, NULL, '📋 Request for duplicate certificates', 5, 5000.00, '10-15 working days', '🏛️ Admin Office, Records Desk', '💰 5 year gap — Rs.5,000'),
(8, '📄 Duplicate Marksheet (>5 Year Gap)', NULL, NULL, '⛔ Not available — Direct University contact required', NULL, NULL, '4-6 weeks (University processing)', '🏫 University Office', '⚠️ Service not available if gap > 5 years'),
(9, '📄 General Bonafide Certificate', NULL, NULL, '🎓 Proof of being a student', NULL, NULL, '2-3 working days', '🏛️ Admin Office, Certificates Desk', '🆓 Free service — No fees'),
(10, '📄 Course Bonafide Certificate', NULL, NULL, '📋 Course enrollment verification', NULL, NULL, '3-4 working days', '🏛️ Admin Office, Academics Desk', '🆓 Free service'),
(11, '🛂 Passport Bonafide Certificate', NULL, NULL, '🛂 Required for passport process', NULL, 50.00, '2-3 working days', '🏛️ Admin Office, Certificates Desk', '💰 Fee: Rs.50'),
(12, '✅ Genuineness Certificate', NULL, NULL, '🔍 Certificate verification', NULL, 500.00, '5-7 working days', '🏛️ Admin Office', '💰 Fee: Rs.500'),
(13, '♿ Disability Student Exemption', NULL, NULL, '📋 Request for exemption from fees/attendance', NULL, NULL, '3-5 working days', '🏛️ Admin Office/Dean Office', '📎 Medical proof required'),
(14, '📄 Bonafide Without Fee Payment', NULL, NULL, '📋 Special case bonafide request', NULL, NULL, '3-5 working days (with approval)', '🏛️ Admin Office, Special Cases', '🔐 Principal approval needed'),
(15, '💼 Fee Structure Certificate', NULL, NULL, '📋 Annual fee details', NULL, NULL, '2-3 working days', '🏛️ Admin Office','🆓 Free service');

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
(1, '📄 Bonafide Certificate (General)', '🏛️ Admin Office', '🎓 Proof of student status at SDNB Vaishnav College', '📋 Request form + Valid ID + Department/Union seals', 0.00, '2-3 working days', '🏛️ Admin Office, Main Building (IT BLOCK) Ground Floor', '🆓 Free service — No fees'),
(2, '💼 Fee Structure Certificate', '🏛️ Finance Office', '💰 Provides annual fee details', '📋 Request form + Fee payment receipt', 0.00, '2-3 working days', '🏛️ Finance Office', '📎 Proof required'),
(3, '🏅 Scholarship Form Application', '🏛️ Admin/Finance Office', '🎓 Apply for scholarship', '📋 Admin approval + Income proof', 0.00, '5-7 working days', '🏛️ Finance Office', '🔍 Verification needed'),
(4, '📄 Course Bonafide', '🏛️ Admin Office', '📋 Course enrollment verification', '📋 Request submission + Valid ID', 0.00, '3-4 working days', '🏛️ Admin Office, Main Building (IT BLOCK) Ground Floor', '🆓 Free service'),
(5, '🚪 Student Outpass', '🏛️ Admin Office', '🏃 Permission to leave campus', '✍️ Class Incharge approval + HOD permission', 0.00, '2-4 hours', '🏛️ Admin Office, Main Building (IT BLOCK) Ground Floor', '📎 Maintain proper proof'),
(6, '🛂 Passport Bonafide', '🏛️ Admin Office', '🛂 Required for passport process', '📋 Request + Valid ID + Admission document copy', 50.00, '2-3 working days', '🏛️ Admin Office, Main Building (IT BLOCK) Ground Floor', '💰 Fee: Rs.50'),
(7, '📜 Medium of Instruction (MOI)', '🏛️ Admin Office', '🗣️ Certificate stating language of instruction (English/Tamil)', '📋 Request submission + Valid ID', 1000.00, '3-4 working days', '🏛️ Admin Office, Main Building (IT BLOCK) Ground Floor', '💰 Fee: Rs.1,000'),
(8, '📅 Attendance Certificate', '🏛️ Admin Office', '📋 Proof of previous semester attendance', '🔍 Record verification + Valid ID', 0.00, '2-3 working days', '🏛️ Admin Office, Main Building Ground Floor', '🆓 Free service'),
(9, '🥇 First Graduation Certificate', '🏛️ Admin Office', '🎓 Proof of first graduate status in family', '📋 Submit declaration if not available', 0.00, '3-4 working days', '🏛️ Admin Office, Main Building (IT BLOCK) Ground Floor', '📎 Alternative proof accepted'),
(10, '🌸 Menstrual Hygiene Product Service', '🏥 College Facility', '💊 Sanitary napkin availability for students', '🪪 Student ID + Request at designated counter', 0.00, 'Immediate ⚡', '🏥 College Health Center ', '🆓 Free service — Token system'),
(11, '🍽️ Subsidized Canteen Meals', '🍽️ Canteen Management', '🥗 Affordable student meal service', '🪪 Student ID + Token purchase', 10.00, 'Immediate ⚡', '🍽️ College Canteen, Opposite to GB BLOCK', 'Collect token from admin Office (IT BLOCK) — 💰 Budget: Rs.10/meal'),
(12, '📢 Complaint Registration Service', '🤝 Union/Admin Office', '📝 Report issues or complaints', '📋 Detailed complaint letter', 0.00, 'Same day registration', '🏛️ Union Office/Admin Office', '✅ Action taken within 7 days'),
(13, '🔍 Missing Items Report', '🏛️ Admin/Union Office', '📦 Report lost/found items on campus', '📋 Submit complaint + Detailed description', 0.00, 'Same day recording', '🏛️ Admin Office/Union Office', '⏳ 30-day claim period'),
(14, '🪪 Lost ID Card Reissue', '🏛️ Admin Office', '🪪 Reissue ID card for lost/damaged cards', '📋 Application form + HOD approval + Declaration form', 250.00, '5-7 working days', '🏛️ Admin Office, Main Building Ground Floor', '💰 Fee: Rs.250'),
(15, '📄 Bonafide Without Fee (Special Cases)', '🏛️ Admin Office', '📋 Request bonafide without paying fees', '🔐 Special permission + Proof of hardship', 0.00, '3-5 working days', '🏛️ Admin Office, Main Building Ground Floor', '🔐 Case-by-case approval'),
(16, '👩‍👧 Single Parent Student Support', '🤝 Admin/Student Affairs', '💛 Support services for single parent students', '📋 Proof of single parent status', 0.00, '5-7 working days', '🏛️ Dean of Student Affairs Office', '📋 Staff approval needed'),
(17, '🔄 Discontinuation and Resumption', '🏛️ Admin Office', '📋 Discontinue and resume studies', '📋 Request submission + Approved reason', 0.00, '5-7 working days', '🏛️ Admin Office, Main Building Ground Floor', '⚠️ No break allowed'),
(18, '♿ Physically Challenged Student Support', '🏛️ Admin Office/COE', '💛 Support for physically challenged students', '📋 Medical proof + COE permission + HOD letter', 0.00, '5-7 working days', '🏛️ Admin Office/Accessibility Office,', '🆓 Free service — Special arrangements');

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
('📚 Academic', 'AC01', '❌ Failed in exams repeatedly', 'தேர்வில் திரும்பவும் தோல்வி', '📋 Consult with Academic Advisor'),
('📚 Academic', 'AC02', '📖 Unable to cope with studies', 'படிப்பை தொடர முடியவில்லை', '👩‍🏫 Meet with Course Instructor'),
('📚 Academic', 'AC03', '🔄 Change of course or institution', 'வேறு படிப்பு / கல்லூரிக்கு மாறுதல்', '🏫 Contact Admissions Office'),
('📚 Academic', 'AC04', '🚌 Transferred to another college', 'வேறு கல்லூரிக்கு இடமாற்றம்', '📋 Complete Admin formalities'),
('👨‍👩‍👧 Personal', 'PE01', '💍 Marriage', 'திருமணம்', '📄 Provide marriage certificate'),
('👨‍👩‍👧 Personal', 'PE02', '🏠 Family responsibilities', 'குடும்ப பொறுப்புகள்', '📝 Submit affidavit'),
('👨‍👩‍👧 Personal', 'PE03', '🕊️ Death of a parent or family member', 'குடும்பத்தினர் இறப்பு', '📄 Submit death certificate'),
('👨‍👩‍👧 Personal', 'PE04', '🗺️ Relocation to another city or state', 'வேறு நகரம் / மாநிலத்திற்கு இடம் மாறுதல்', '📋 Update address with admin'),
('💰 Financial', 'FI01', '💸 Unable to pay fees', 'கட்டணம் செலுத்த இயலவில்லை', '🏛️ Contact Finance Office'),
('💰 Financial', 'FI02', '📉 Financial hardship or family income loss', 'நிதி சிரமம்', '📋 Submit income proof'),
('💰 Financial', 'FI03', '👷 Need to work to support family', 'குடும்பத்தை ஆதரிக்க வேலைக்கு செல்வது', '🤝 Discuss with Admin'),
('🏥 Health', 'HE01', '🤒 Long-term medical illness', 'நீண்ட நாள் நோய்', '📄 Submit medical certificate'),
('🏥 Health', 'HE02', '🧠 Mental health issues', 'மன நலப் பிரச்சினை', '💛 Contact Counseling Center'),
('🏥 Health', 'HE03', '♿ Physical disability or accident', 'உடல் ஊனம் / விபத்து', '📋 Register with Disability Services'),
('💼 Career', 'CA01', '🎯 Got a job', 'வேலை கிடைத்தது', '📄 Request TC'),
('💼 Career', 'CA02', '📝 Pursuing competitive exams (UPSC/TNPSC)', 'போட்டித் தேர்வுகளுக்கு படிக்கிறேன்', '💬 Discuss options with admin'),
('💼 Career', 'CA03', '🏢 Started own business', 'சொந்த தொழில் தொடங்கியது', '📋 Submit business proof'),
('💼 Career', 'CA04', '🎖️ Selected in armed forces or government service', 'அரசு / ராணுவ சேவையில் சேர்ந்தது', '⚡ Request expedited TC'),
('🔖 Other', 'OT01', '🔒 Personal reasons (undisclosed)', 'தனிப்பட்ட காரணம்', '💬 Discuss with HOD'),
('🔖 Other', 'OT02', '📋 Others', 'மற்றவை', '🏛️ Contact Admin Office');

-- =========================
-- ✅ VERIFICATION QUERIES
-- =========================

SELECT '📊 chatbot_intents table check' as verification, COUNT(*) as total_rows FROM chatbot_intents;
SELECT '📊 policies table check' as verification, COUNT(*) as total_rows FROM policies;
SELECT '📊 attendance_categories check' as verification, COUNT(*) as total_rows FROM attendance_categories;
SELECT '📊 student_requests check' as verification, COUNT(*) as total_rows FROM student_requests;
SELECT '📊 admin_services check' as verification, COUNT(*) as total_rows FROM admin_services;
SELECT '📊 dropout_reasons check' as verification, COUNT(*) as total_rows FROM dropout_reasons;

-- =========================
-- 📋 DISPLAY SAMPLE DATA
-- =========================

SELECT '🤖 Chatbot Intents Sample' as title;
SELECT intent_id, intent_name, module_id, processing_time, fees, office_location FROM chatbot_intents LIMIT 5;

SELECT '📜 Policies Sample' as title;
SELECT policy_id, policy_title, value_numeric, due_date FROM policies LIMIT 5;

SELECT '📅 Attendance Categories Sample' as title;
SELECT category_code, min_percent, max_percent, action_required, fee_applicable FROM attendance_categories;
