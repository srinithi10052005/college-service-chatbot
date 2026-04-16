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
-- 2. CHATBOT INTENTS (CORRECTED)
-- =========================
CREATE TABLE chatbot_intents (
    intent_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    language VARCHAR(20) NOT NULL,
    intent_name VARCHAR(100) NOT NULL,
    keywords TEXT NOT NULL,
    response TEXT NOT NULL,
    processing_time VARCHAR(50) DEFAULT NULL,
    fees DECIMAL(10,2) DEFAULT NULL,
    office_location VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO chatbot_intents (intent_id, module_id, language, intent_name, keywords, response, processing_time, fees, office_location) 
VALUES 
(1, 1, 'English', 'greeting', 'hi, hello, hey, good morning, good afternoon, good evening', '👋 Welcome to SDNB ASKNOVA. I am your service assistant. How can I help you today?', NULL, NULL, NULL),
    
(2, 1, 'Tamil', 'greeting', 'வணக்கம், ஹாய், ஹலோ, காலை வணக்கம், மாலை வணக்கம்', '👋 எஸ்டிஎன்பி ASKNOVA-க்கு வரவேற்கிறோம். நான் உங்கள் சேவை உதவியாளர். உங்கள் கேள்விகளுக்கு உதவ தயாராக உள்ளேன்.', NULL, NULL, NULL),
    
(3, 3, 'English', 'outpass', 'outpass, out pass, gate pass, leave permission', '📋 Outpass Procedure (Processing Time: 2-4 hours):\n1. Visit Class Incharge\n2. Get HOD permission\n3. Visit Admin Office\n📞 Contact: Admin Office', '2-4 hours', NULL, 'Admin Office, Main Building, Ground Floor'),

(4, 3, 'Tamil', 'outpass', 'அவுட்பாஸ், வெளியே செல்ல அனுமதி', '📋 அவுட்பாஸ் நடைமுறை:\n1. Class Incharge-ஐ சந்தியுங்கள்\n2. HOD அனுமதி பெறுங்கள்\n3. Admin Office-ற்குச் செல்லுங்கள்\n📞 தொடர்பு: Admin Office', '2-4 மணிநேரம்', NULL, 'Admin Office, முதன்மை கட்டடம், தாழ்வாரம்'),

(5, 4, 'English', 'bonafide', 'bonafide', '📜 There are multiple Bonafide Certificates available:\n1. **General** (Free)\n2. **Course** (Free)\n3. **Passport** (₹50)\n👉 Type the specific certificate you need.\n📍 Location: Admin Office\n⏰ Timings: Mon-Fri, 9:00 AM\n📞 Contact: Evening Office', NULL, NULL, 'Admin Office, Main Building, Ground Floor'),

(6, 4, 'Tamil', 'bonafide', 'போனாபைடு', '📜 பல வகையான Bonafide Certificates உள்ளன:\n1. **General** (இலவசம்)\n2. **Course** (இலவசம்)\n3. **Passport** (₹50)\n👉 தேவையான சான்றிதழை குறிப்பிடுங்கள்.\n📍 இடம்: Admin Office\n⏰ நேரம்: 9:00 AM - 4:30 PM', NULL, NULL, 'Admin Office, Main Building (IT Block), Ground Floor'),

(7, 4, 'English', 'tc_procedure', 'tc, transfer certificate', '📋 Transfer Certificate Procedure (Pass Out Students)\nProcessing Time: 7-10 working days\n1. Visit Dept Office\n2. Get HOD signature\n3. Library Clearance\n📍 Library: GB Block, 1st Floor', '7-10 working days', NULL, 'Admin Office, Main Building (IT Block), Ground Floor'),

(8, 4, 'Tamil', 'tc_procedure', 'tc, transfer certificate', '📋 Transfer Certificate பெறும் நடைமுறை\n1. துறை அலுவலகத்திற்குச் செல்லுங்கள்\n2. HOD கையொப்பம் பெறுங்கள்\n3. நூலக சரியாக்கல் பெறுங்கள்\n📍 நூலகம்: பிளாக்-A', '7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(9, 3, 'English', 'missing_id', 'missing id, id card lost', '🆔 Missing ID Card Reissue\nFee: ₹250\n1. Inform Incharge\n2. Pay ₹250 at Cash Counter\n3. Collect new ID in 2-4 days\n⚠️ Note: Entry restricted without ID', '2-4 working days', 250.00, 'Admin Office, Main Building (IT Block), Ground Floor'),

(10, 3, 'Tamil', 'missing_id', 'ஐடி கார்டு தொலைந்தது', '🆔 ID அட்டை மீண்டும் பெறுதல்\nகட்டணம்: ₹250\n1. Incharge-க்கு தகவல் சொல்லுங்கள்\n2. ₹250 கட்டணம் செலுத்துங்கள்\n⚠️ குறிப்பு: ID இல்லாமல் நுழைய அனுமதி இல்லை', '2-4 working days', 250.00, 'Admin Office, Main Building, Ground Floor'),

(11, 6, 'English', 'exam_eligibility', 'exam eligibility', '📚 Exam Eligibility:\nCategory A (≥ 75%): ✅ ELIGIBLE\nCategory B (65-74%): ⚠️ CONDONATION (₹250)\nCategory C (< 65%): ❌ NOT ELIGIBLE\n💡 Tip: Maintain 75% attendance', NULL, 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(12, 6, 'Tamil', 'exam_eligibility', 'தேர்வு தகுதி', '📚 தேர்வு தகுதி:\nCategory A (≥ 75%): ✅ தகுதி உள்ளது\nCategory B (65-74%): ⚠️ ₹250 கட்டணம்\nCategory C (< 65%): ❌ தகுதி இல்லை\n💡 குறிப்பு: 75% attendance அவசியம்', NULL, 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(13, 4, 'English', 'tc_discontinued', 'dropout tc', '📋 TC Procedure (Discontinued)\n1. HOD approval\n2. Library Clearance\n3. Original Admission docs\n💡 Provide reason for discontinuation', '7-10 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(14, 4, 'Tamil', 'tc_discontinued', 'படிப்பை நிறுத்தினால் tc', '📋 TC நடைமுறை (நிறுத்திய மாணவர்கள்)\n1. HOD அனுமதி\n2. நூலக சரியாக்கல்\n3. அசல் ஆவணங்கள் சமர்ப்பிக்கவும்\n💡 நிறுத்தும் காரணம் தேவை', '7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(15, 4, 'English', 'bonafide_general', 'general bonafide', '📜 General Bonafide\nFee: FREE\n1. Collect form\n2. Dept seal\n3. Submit to Evening Office\n💡 No fees required', '2-3 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

(16, 4, 'English', 'course_bonafide', 'course bonafide', '📜 Course Bonafide\nFee: FREE\n1. Fill form at Admin Office\n2. Verify enrollment\n3. Collect in 3-4 days', '3-4 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(17, 4, 'English', 'passport_bonafide', 'passport bonafide', '📜 Passport Bonafide\nFee: ₹50\n1. Attach ID copy\n2. Pay ₹50 fee\n3. Collect in 2-3 days', '2-3 working days', 50.00, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(18, 4, 'English', 'bonafide_without_fee', 'no fee bonafide', '📜 Bonafide Without Fee\n1. Request letter\n2. Financial proof\n3. Principal approval\n⚠️ Approval is NOT automatic', '3-5 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(21, 4, 'English', 'marksheet_lost', 'duplicate marksheet', '📄 Duplicate Marksheet\nFee: Based on year gap (₹1,000 - ₹5,000)\n1. Fill form\n2. Submit with Police FIR\n📍 Location: IT Block', '10-15 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(22, 4, 'Tamil', 'marksheet_lost', 'மார்க்ஷீட் தொலைந்தது, duplicate marksheet', '📄 Duplicate மார்க்ஷீட் பெறும் நடைமுறை\n1. விண்ணப்பப் படிவம்\n2. ஆண்டு இடைவெளிக்கு ஏற்ப கட்டணம்\n📍 இடம்: Admin Office, தாழ்வாரம்\n📞 தொடர்பு: Evening Office', '10-15 working days', NULL, 'Admin Office, முதன்மை கட்டடம், தாழ்வாரம்');
-- =========================
-- 3. POLICIES (ENHANCED)
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
(1, 2, 'English', 'Semester Fee', 'Annual fee per semester', NULL, 'Due on registration', FALSE, TRUE, 'Before semester starts', 'Finance Office, refer admin office'),
(2, 2, 'English', 'Late Fee', 'Fine applicable after due date (₹500 per day)', 500.00, 'Fine Applicable', TRUE, FALSE, '7 days after due date', 'Finance Office'),
(3, 2, 'English', 'Hostel Fee', 'Annual hostel charges for residents', 30000.00, 'Payable once a year', FALSE, FALSE, 'Before hostel registration', 'Hostel Office'),
(4, 2, 'Tamil', 'செமிஸ்டர் கட்டணம்', 'ஒரு செமிஸ்டருக்கு ஆண்டு கட்டணம்', NULL, 'பதிவுக்கு முன் செலுத்த வேண்டும்', FALSE, TRUE, 'செமிஸ்டர் தொடங்குவதற்கு முன்', 'Finance Office'),
(5, 2, 'Tamil', 'தாமத கட்டணம்', 'கட்டணத்தின் கடைசி தேதிக்குப் பிறகு அபராதம் (₹500 நாளொன்றுக்கு)', 500.00, 'அபராதம் பொருந்தும்', TRUE, FALSE, 'கடைசி தேதிக்கு 7 நாட்களுக்குப் பிறகு', 'Finance Office'),
(6, 3, 'English', 'Medical Leave', 'Medical certificate required for absence', NULL, 'Medical Certificate Required', FALSE, FALSE, 'Within 3 days of return', 'Department'),
(7, 3, 'Tamil', 'மருத்துவ விடுப்பு', 'விடுப்புக்கு மருத்துவச் சான்றிதழ் தேவை', NULL, 'மருத்துவச் சான்றிதழ் அவசியம்', FALSE, FALSE, 'திரும்பிய 3 நாட்களுக்குள்', 'Department'),
(8, 4, 'English', 'Transfer Certificate', 'Students must complete department and office clearance before receiving TC.', NULL, 'Clearance Required (7-10 days)', FALSE, FALSE, 'Immediate', 'Department & Admin Office'),
(9, 4, 'Tamil', 'மாற்றுச் சான்றிதழ்', 'TC பெற துறை மற்றும் அலுவலக clearance முடிக்க வேண்டும்.', NULL, 'Clearance அவசியம் (7-10 நாட்கள்)', FALSE, FALSE, 'உடனடியாக', 'Department & Admin Office'),
(10, 6, 'English', 'Attendance Requirement', 'Minimum 75% attendance required to write exam', 75, 'Minimum 75%', FALSE, FALSE, NULL, 'Department & Admin Office'),
(11, 6, 'English', 'Condonation Fee', 'Condonation fee for 65-74% attendance', 250.00, '₹250 condonation fee', TRUE, FALSE, '3 days before exam', 'Admin Office, Cash Counter'),
(12, 6, 'Tamil', 'Attendance Requirement', 'தேர்வு எழுத குறைந்தபட்சம் 75% attendance தேவை', 75, 'குறைந்தபட்சம் 75%', FALSE, FALSE, NULL, 'Department & Admin Office');
-- =========================
-- 4. ATTENDANCE CATEGORIES (ENHANCED)
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
(2, 'B', 65, 74, 'English', 'Category B - Condonation', 'Condonation fee Rs.250 must be paid before exam', 'Pay ₹250 3 days before exam', 250.00),
(3, 'C', 50, 64, 'English', 'Category C - Not Allowed', 'Not allowed to write exam. Must repeat course.', 'Contact HOD for re-registration', NULL),
(4, 'D', 1, 49, 'English', 'Category D - Repeat', 'Must repeat entire course next semester', 'Visit Academic Office for re-admission', NULL),
(5, 'E', 0, 0, 'English', 'Category E - Rejoin', 'Must rejoin college in next academic year', 'Report to Principal''s Office', NULL),
(6, 'A', 75, 100, 'Tamil', 'வகை A - தகுதியுள்ள', 'எந்தவொரு கட்டுப்பாடும் இல்லாமல் தேர்வு எழுதலாம்', NULL, NULL),
(7, 'B', 65, 74, 'Tamil', 'வகை B - Condonation', 'தேர்வுக்கு முன் ₹250 condonation fee செலுத்த வேண்டும்', 'தேர்வுக்கு 3 நாட்களுக்கு முன் ₹250 செலுத்துங்கள்', 250.00),
(8, 'C', 50, 64, 'Tamil', 'வகை C - நிறுத்தப்பட்ட', 'தேர்வு எழுத அனுமதி இல்லை. பாடத்தை மீண்டும் படிக்க வேண்டும்.', 'மீண்டும் பதிவு செய்ய HOD-ஐ தொடர்புகொள்ளுங்கள்', NULL),
(9, 'D', 1, 49, 'Tamil', 'வகை D - மீண்டும் படிக்க', 'அடுத்த செமிஸ்டரில் முழு பாடத்தையும் மீண்டும் படிக்க வேண்டும்', 'Academic Office-ற்கு சென்று மீண்டும் சேர்க்கை செய்யுங்கள்', NULL),
(10, 'E', 0, 0, 'Tamil', 'வகை E - மீண்டும் சேர்க', 'அடுத்த கல்வி ஆண்டில் கல்லூரியில் மீண்டும் சேர்க வேண்டும்', 'Principal Office-க்கு செல்லுங்கள்', NULL);

-- =========================
-- 5. STUDENT REQUESTS (DETAILED)
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
(1, 'Dropout/Discontinuation', 'Specify year', 'Academic/Personal/Financial/Health/Career/Other', 'Apply with reason proof', NULL, NULL, '7-10 working days', 'Admin Office, Ground Floor', 'All supporting documents required, HOD approval needed'),
(2, 'Medium of Instruction (MOI)', NULL, NULL, 'For job/higher studies', NULL, 1000.00, '3-4 working days', 'Admin Office', 'Charges applicable, English/Tamil medium certificate'),
(3, 'Duplicate Marksheet (1 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 1, 1000.00, '10-15 working days', 'Admin Office, Records Desk', '1 year gap - ₹1,000 (includes ₹100 processing fee)'),
(4, 'Duplicate Marksheet (2 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 2, 2000.00, '10-15 working days', 'Admin Office, Records Desk', '2 year gap - ₹2,000 (includes ₹100 processing fee)'),
(5, 'Duplicate Marksheet (3 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 3, 3000.00, '10-15 working days', 'Admin Office, Records Desk', '3 year gap - ₹3,000 (includes ₹100 processing fee)'),
(6, 'Duplicate Marksheet (4 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 4, 4000.00, '10-15 working days', 'Admin Office, Records Desk', '4 year gap - ₹4,000 (includes ₹100 processing fee)'),
(7, 'Duplicate Marksheet (5 Year Gap)', NULL, NULL, 'Request for duplicate certificates', 5, 5000.00, '10-15 working days', 'Admin Office, Records Desk', '5 year gap - ₹5,000 (includes ₹100 processing fee)'),
(8, 'Duplicate Marksheet (>5 Year Gap)', NULL, NULL, 'Not available - Direct University contact required', NULL, NULL, '4-6 weeks (University processing)', 'University Office', 'Service not available if gap > 5 years, Direct University contact needed'),
(9, 'General Bonafide Certificate', NULL, NULL, 'Proof of being a student', NULL, NULL, '2-3 working days', 'Admin Office, Certificates Desk', 'Free service, No fees, Required for scholarships/loans'),
(10, 'Course Bonafide Certificate', NULL, NULL, 'Course enrollment verification', NULL, NULL, '3-4 working days', 'Admin Office, Academics Desk', 'Free service, Used for semester admissions'),
(11, 'Passport Bonafide Certificate', NULL, NULL, 'Required for passport process', NULL, 50.00, '2-3 working days', 'Admin Office, Certificates Desk', 'Fee: ₹50, Mandatory for passport applications'),
(12, 'Genuineness Certificate', NULL, NULL, 'Certificate verification/authenticity', NULL, 500.00, '5-7 working days', 'Admin Office', 'Used for official verification purposes'),
(13, 'Disability Student Exemption', NULL, NULL, 'Request for exemption from fees/attendance', NULL, NULL, '3-5 working days', 'Admin Office/Dean Office', 'Submit medical proof + COE permission, HOD letter required'),
(14, 'Bonafide Without Fee Payment', NULL, NULL, 'Special case bonafide request', NULL, NULL, '3-5 working days (with approval)', 'Admin Office, Special Cases', 'Requires proof of financial hardship, Principal approval needed'),
(15, 'Fee Structure Certificate', NULL, NULL, 'Annual fee details', NULL, NULL, '2-3 working days', 'Finance Office, Block-B', 'Free service, Proof of fee payment required');

-- =========================
-- 6. ADMIN SERVICES (DETAILED)
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
(1, 'Bonafide Certificate (General)', 'Admin Office', 'Proof of student status', 'Request form submission + Valid ID + Department/Union seals', 0.00, '2-3 working days', 'Admin Office, Main Building Ground Floor(IT BLOCK)', 'Basic verification, No fees, Required for scholarships'),
(2, 'Fee Structure Certificate', 'Finance Office', 'Provides annual fee details', 'Request form submission + Fee payment receipt', 0.00, '2-3 working days', 'Finance Office, ', 'Proof required, Valid for 1 academic year'),
(3, 'Scholarship Form Application', 'Admin/Finance Office', 'Apply for scholarship', 'Approval from admin team + Income proof', 0.00, '5-7 working days', 'Finance Office, ', 'Verification needed, Based on merit/financial criteria'),
(4, 'Course Bonafide', 'Admin Office', 'Course enrollment verification', 'Request submission + Valid ID + Registration number', 0.00, '3-4 working days', 'Admin Office, Main Building Ground Floor (IT BLOCK)', 'Free service, Used for semester verification'),
(5, 'Student Outpass', 'Admin Office', 'Permission to leave campus', 'Class Incharge approval + HOD permission + Request form', 0.00, '2-4 hours', 'Admin Office, Main Building Ground Floor (IT BLOCK)', 'Maintain proper proof, Valid for single day'),
(6, 'Passport Bonafide', 'Admin Office', 'Required for passport process', 'Request submission + Valid ID + Admission document copy', 50.00, '2-3 working days', 'Admin Office, Main Building Ground Floor (IT BLOCK)', 'Fee: ₹50 (usually in exam fees), Mandatory for passport'),
(7, 'Medium of Instruction (MOI)', 'Admin Office', 'Certificate stating language (English/Tamil)', 'Request submission + Valid ID', 1000.00, '3-4 working days', 'Admin Office, Main Building Ground Floor(IT BLOCK)', 'Fee: ₹1,000, Required for job/higher studies applications'),
(8, 'Attendance Certificate', 'Admin Office', 'Proof of previous semester attendance', 'Record verification + Valid ID + Semester details', 0.00, '2-3 working days', 'Admin Office, Main Building Ground Floor(IT BLOCK)', 'Free service, Verified from official records'),
(9, 'First Graduation Certificate', 'Admin Office', 'Proof of first graduate status', 'Submit declaration if not available + Transcript copy', 0.00, '3-4 working days', 'Admin Office, Main Building Ground Floor(IT BLOCK)', 'Alternative proof accepted, Required for jobs/higher studies'),
(10, 'Menstrual Hygiene Product Service', 'College Facility', 'Sanitary napkin availability for students', 'Student ID + Request at designated counter', 0.00, 'Immediate', 'College Health Center', 'Free service, Token system in place, No charges'),
(11, 'Subsidized Canteen Meals', 'Canteen Management', 'Affordable student meal service', 'Student ID + Token purchase (₹10-15)', 10.00, 'Immediate', 'College Canteen, Behind Main Building', 'Budget: ₹10/meal, Includes rice, sambar, pickle, vegetables'),
(12, 'Complaint Registration Service', 'Union/Admin Office', 'Report issues or complaints', 'Detailed complaint letter + Witness signature (if needed)', 0.00, 'Same day registration', 'Union Office/Admin Office', 'Students can file complaints, Recorded in complaint log, Action within 7 days'),
(13, 'Missing Items Report (Lost & Found)', 'Admin/Union Office', 'Report lost/found items on campus', 'Submit complaint + Detailed description + Timestamp', 0.00, 'Same day recording', 'Admin Office/Union Office', 'Recorded as Missing Note, 30-day claim period, No fee'),
(14, 'Lost ID Card Reissue', 'Admin Office', 'Reissue ID card for lost/damaged cards', 'Application form + HOD approval + Declaration form', 250.00, '5-7 working days', 'Admin Office, Main Building Ground Floor', 'Fee: ₹250, Bonafide letter required, Provisional ID valid 15 days'),
(15, 'Bonafide Without Fee (Special Cases)', 'Admin Office', 'Request bonafide without paying fees', 'Special permission required + Proof of hardship + Principal approval', 0.00, '3-5 working days', 'Admin Office, Main Building Ground Floor', 'Free service for approved cases, Case-by-case approval'),
(16, 'Single Parent Student Support', 'Admin/Student Affairs', 'Support services for single parent students', 'Proof of single parent status + Court decree/Death certificate', 0.00, '5-7 working days', 'Dean of Student Affairs Office', 'Staff approval needed, Eligible for fee waivers/scholarships'),
(17, 'Discontinuation & Resumption', 'Admin Office', 'Discontinue and resume studies', 'Request submission + Approved reason + HOD clearance', 0.00, '5-7 working days', 'Admin Office, Main Building Ground Floor(IT BLOCK)', 'No break allowed, Academic standing maintained'),
(18, 'Physically Challenged Student Support', 'Admin Office/COE', 'Support for physically challenged students', 'Medical proof + COE permission + HOD letter + Special needs form', 0.00, '5-7 working days', 'Admin Office/Accessibility Office, ', 'Free service, Includes facility arrangements, Special seating, etc.');

-- =========================
-- 7. DROPOUT REASONS
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

-- Academic
('Academic', 'AC01', 'Failed in exams repeatedly',         'தேர்வில் திரும்பவும் தோல்வி', 'Consult with Academic Advisor, Consider peer tutoring'),
('Academic', 'AC02', 'Unable to cope with studies',        'படிப்பை தொடர முடியவில்லை', 'Meet with Course Instructor, Request for course change'),
('Academic', 'AC03', 'Change of course or institution',    'வேறு படிப்பு / கல்லூரிக்கு மாறுதல்', 'Contact Admissions Office, Get TC/Transfer certificate'),
('Academic', 'AC04', 'Transferred to another college',     'வேறு கல்லூரிக்கு இடமாற்றம்', 'Complete Admin formalities, Collect TC within 7 days'),

-- Personal / Family
('Personal', 'PE01', 'Marriage',                           'திருமணம்', 'Provide marriage certificate, Apply for TC'),
('Personal', 'PE02', 'Family responsibilities',            'குடும்ப பொறுப்புகள்', 'Submit affidavit, Discuss discontinuation options'),
('Personal', 'PE03', 'Death of a parent or family member', 'குடும்பத்தினர் இறப்பு', 'Submit death certificate, Request fee waiver if eligible'),
('Personal', 'PE04', 'Relocation to another city or state','வேறு நகரம் / மாநிலத்திற்கு இடம் மாறுதல்', 'Apply for TC, Update address with admin'),

-- Financial
('Financial', 'FI01', 'Unable to pay fees',               'கட்டணம் செலுத்த இயலவில்லை', 'Contact Finance Office, Apply for scholarship/installment'),
('Financial', 'FI02', 'Financial hardship or family income loss', 'நிதி சிரமம்', 'Submit income proof, Request fee waivercondonation'),
('Financial', 'FI03', 'Need to work to support family',   'குடும்பத்தை ஆதரிக்க வேலைக்கு செல்வது', 'Discuss distance/correspondence options with admin'),

-- Health
('Health',    'HE01', 'Long-term medical illness',         'நீண்ட நாள் நோய்', 'Submit medical certificate, Request medical leave/discontinuation'),
('Health',    'HE02', 'Mental health issues',              'மன நலப் பிரச்சினை', 'Contact Counseling Center, Discuss academic adjustments'),
('Health',    'HE03', 'Physical disability or accident',   'உடல் ஊனம் / விபத்து', 'Register with Disability Services, Request accommodations'),

-- Career / Opportunity
('Career',    'CA01', 'Got a job',                         'வேலை கிடைத்தது', 'Request TC, Inform within 15 days'),
('Career',    'CA02', 'Pursuing competitive exams (UPSC/TNPSC)', 'போட்டித் தேர்வுகளுக்கு படிக்கிறேன்', 'Discuss correspondence/distance learning options'),
('Career',    'CA03', 'Started own business',              'சொந்த தொழில் தொடங்கியது', 'Submit business proof, Apply for discontinuation'),
('Career',    'CA04', 'Selected in armed forces or government service', 'அரசு / ராணுவ சேவையில் சேர்ந்தது', 'Request expedited TC, Submit appointment letter'),

-- Other
('Other',     'OT01', 'Personal reasons (undisclosed)',     'தனிப்பட்ட காரணம்', 'Discuss with HOD, Meet Dean of Students if needed'),
('Other',     'OT02', 'Others',                            'மற்றவை', 'Contact Admin Office for specific guidance');

-- Verify all inserts
SELECT COUNT(*) as total_intents FROM chatbot_intents;
SELECT COUNT(*) as total_policies FROM policies;
SELECT COUNT(*) as total_services FROM admin_services;
SELECT COUNT(*) as total_dropout_reasons FROM dropout_reasons;
