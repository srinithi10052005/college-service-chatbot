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

INSERT INTO chatbot_intents (intent_id, module_id, language, intent_name, keywords, response, processing_time, fees, office_location) VALUES

-- Greeting
(1, 1, 'English', 'greeting',
'hi, hello, hey, good morning, good afternoon, good evening',
'👋 Welcome to SDNB ASKNOVA. I am your service assistant. How can I help you today?',
NULL, NULL, NULL),

(2, 1, 'Tamil', 'greeting',
'வணக்கம், ஹாய், ஹலோ, காலை வணக்கம், மாலை வணக்கம்',
'👋 எஸ்டிஎன்பி ASKNOVA-க்கு வரவேற்கிறோம். நான் உங்கள் சேவை உதவியாளர். உங்கள் கேள்விகளுக்கு உதவ தயாராக உள்ளேன்.',
NULL, NULL, NULL),

-- Outpass
(3, 3, 'English', 'outpass',
'outpass, out pass, how to get outpass, outpass procedure, gate pass, leave permission, campus leave, permission to leave, permission to go outside, campus exit permission, go outside permission, exit campus',
'📋 Outpass Procedure (Processing Time: 2-4 hours):
1. Visit your Class Incharge in your department
2. Get written permission from HOD 
3. Visit Admin Office (Main Building(IT Block), Ground Floor) with approval letter
4. Enter your details in the outpass register with time OUT and IN
5. Show the outpass at the main gate to security personnel
6. Return the outpass to Admin Office upon return to campus
📞 Contact: Admin Office - Evening Office (Mon-Fri, 9:00 AM - 4:30 PM)',
'2-4 hours', NULL, 'Admin Office, Main Building, Ground Floor'),

(4, 3, 'Tamil', 'outpass',
'அவுட்பாஸ், வெளியே செல்ல அனுமதி, outpass procedure',
'📋 அவுட்பாஸ் நடைமுறை 
1. முதலில் உங்கள் Class Incharge-ஐ உங்கள் துறையில் சந்தியுங்கள்
2. HOD-ஐ தொடர்புகொண்டு அனுமதிப்பத்திரம் பெறுங்கள் (அலுவலகம்: துறை ப்ளாக், 2வது மாடி)
3. அனுமதிப்பத்திரத்துடன் Admin Office-ற்குச் செல்லுங்கள் (முதன்மை கட்டடம், தாழ்வாரம்)
4. அவுட்பாஸ் பதிவேட்டில் நுழைந்த நேரம் மற்றும் வெளியேறிய நேரம் பதிவு செய்யுங்கள்
5. பாதுகாப்பாளரிடம் முதன்மை வாயிலில் அவுட்பாஸ் காட்டுங்கள்
6. வெளியேறுவதற்கு முன் Admin Office-ற்கு அவுட்பாஸ் திருப்பி அளியுங்கள்
📞 தொடர்பு: Admin Office -Evening Office (திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM)',
'2-4 மணிநேரம்', NULL, 'Admin Office, முதன்மை கட்டடம், தாழ்வாரம்'),

-- Bonafide main menu
(5, 4, 'English', 'bonafide',
'bonafide',
'📜 There are multiple Bonafide Certificates available:

1. **General Bonafide Certificate** (Free) - Processing: 2-3 days
   Proof of student status. Required for general purposes.

2. **Course Bonafide** (Free) - Processing: 3-4 days
   Verification of current course enrollment.

3. **Passport Bonafide** (₹50) - Processing: 2-3 days
   Required for passport applications.

4. **Bonafide Without Fee Payment** (Free with Special Permission)
   Approved only for students with genuine financial hardship.

👉 Please type the specific certificate you need:
- Type: general bonafide
- Type: course bonafide
- Type: passport bonafide
- Type: bonafide without fee

📍 Location: Admin Office, Main Building (IT Block), Ground Floor
⏰ Timings: Mon-Fri, 9:00 AM - 4:30 PM
📞 Contact: Evening Office',
NULL, NULL, 'Admin Office, Main Building, Ground Floor'),

(6, 4, 'Tamil', 'bonafide',
'போனாபைடு, போனாபைடு சான்றிதழ்',
'📜 பல வகையான Bonafide Certificates உள்ளன:

1. **General Bonafide Certificate** (இலவசம்) - செயல்படுத்தும் நேரம்: 2-3 நாட்கள்
   மாணவர் நிலையின் சான்றாக உள்ளது.

2. **Course Bonafide** (இலவசம்) - செயல்படுத்தும் நேரம்: 3-4 நாட்கள்
   தற்போதைய பாடநெறி சேர்க்கையின் சரிதGraphics.

3. **Passport Bonafide** (₹50) - செயல்படுத்தும் நேரம்: 2-3 நாட்கள்
   பாஸ்போர்ட் விண்ணப்பங்களுக்கு தேவை.

4. **Fee இல்லாமல் Bonafide** (இலவசம், சிறப்பு அனுமதியுடன்)
   நிதி சிரமத்தில் உள்ள மாணவர்களுக்கு மட்டுமே அனுமதிக்கப்படுகிறது.

👉 தயவு செய்து உங்களுக்கு தேவையான சான்றிதழை குறிப்பிடுங்கள்:
- Type: general bonafide
- Type: course bonafide
- Type: passport bonafide
- Type: bonafide without fee

📍 இடம்: Admin Office, முதன்மை கட்டடம், தாழ்வாரம்
⏰ நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM
📞 தொடர்பு: Evening Block',
NULL, NULL, 'Admin Office, Main Building (IT Block), Ground Floor'),

-- TC passout
(7, 4, 'English', 'tc_procedure',
'tc, tc procedure, transfer certificate, how to get tc, tc process, certificate process, tc for pass out, passout tc, tc for passout',
'📋 Transfer Certificate Procedure (Pass Out Students)
Processing Time: 7-10 working days

Step-by-Step Process:
1. Visit Department Office with application form 
2. Get department HOD signature and stamp
3. Collect clearance certificate from:
   - Department Head
   - Library Staff (Return all books - Book Counter, GB Block)
   - Hostel Warden (if applicable - Hostel Office)
4. Complete office clearance at Admin Office with receipts
5. Submit final documents to Admin Office
6. Collect TC Certificate from Admin Office

📍 Locations:
- Library:GB Block , !st Floor
- Hostel: Hostel Office, Behind Main Gate
- Admin Office: IT Block, Ground Floor

📞 Contact: Admin Office - Evening Office
⏰ Office Hours: Mon-Fri, 9:00 AM - 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building (IT Block), Ground Floor'),

(8, 4, 'Tamil', 'tc_procedure',
'tc, transfer certificate, tc நடைமுறை',
'📋 Transfer Certificate பெறும் நடைமுறை (பட்டம் பெற்ற மாணவர்கள்)
செயல்படுத்தும் நேரம்: 7-10 வேலை நாட்கள்

படிப்படியான நடைமுறை:
1. விண்ணப்பப் படிவத்துடன் துறை அலுவலகத்திற்குச் செல்லுங்கள் (துறை கவுண்டரில் கோரவும்)
2. துறைத் தலைவர் கையொப்பம் மற்றும் முத்திரை பெறுங்கள்
3. சரியாக்கல் சான்றிதழ் சேகரிக்கவும்:
   - துறை தலைவர்
   - நூலகக் কর্মचারி (அனைத்து புத்தகங்களை திருப்பி அளியுங்கள் - புத்தக கவுண்டர், பிளாக்-A)
   - விடுதி வாரியம் (பொருந்தினால் - விடுதி அலுவலகம்)
4. Admin Office-ற்கு ரசீதுகளுடன் அலுவலக சரியாக்கல் முடிக்கவும்
5. Admin Office-ற்கு இறுதி ஆவணங்களை சமர்ப்பிக்கவும்
6. Admin Office-ல் இருந்து TC சான்றிதழ் சேகரிக்கவும்

📍 இடங்கள்:
- துறை அலுவலகம்: துறை ப்ளாக், 1வது மாடி
- நூலகம்: பிளாக்-A, முதன்மை கட்டடம்
- விடுதி: விடுதி அலுவலகம், முதன்மை வாயிலுக்கு பின்னால்
- Admin Office: முதன்மை கட்டடம், தாழ்வாரம்


⏰ அலுவலக நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

-- Missing ID
(9, 3, 'English', 'missing_id',
'missing id, id card lost, lost id, lost id card, id lost, duplicate id, duplicate id card, id card procedure, missing id procedure',
'🆔 Missing ID Card Reissue Procedure
Processing Time: 5-7 working days
Fee: ₹250

Step-by-Step Process:
1. Inform your Class Incharge (within the shift timing)
2. Inform your Department HOD in writing
3. Visit Admin Office (Main Building (IT Block), Ground Floor) with:
   - Lost ID Declaration Form (Available at Admin Office)
   - Written notification from Class Incharge
   - HOD Approval Letter
4. Submit form and pay reissue fee of ₹250 at Cash Counter
5. Collect provisional ID receipt (valid for 15 days)
6. Report to Campus Security with receipt
7. Collect new ID card after 2-4 working days

📍 Location: Admin Office, Main Building (IT Block), Ground Floor
📞 Contact: Evening Office (ID Desk)
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM
⚠️ Note: Without ID, you may face entry restrictions at campus gates',
'2-4 working days', 250.00, 'Admin Office, Main Building (IT Block), Ground Floor'),

(10, 3, 'Tamil', 'missing_id',
'மிஸ்ஸிங் ஐடி, அடையாள அட்டை தொலைந்தது, id card காணவில்லை',
'🆔 ID அட்டை மீண்டும் வெளியீடு செய்யும் நடைமுறை
செயல்படுத்தும் நேரம்: 2-4 வேலை நாட்கள்
கட்டணம்: ₹250

படிப்படியான நடைமுறை:
1. உங்கள் Class Incharge-க்கு தகவல் சொல்லுங்கள் (இழப்பிலிருந்து 24 மணிநேரத்திற்குள்)
2. உங்கள் துறை HOD-க்கு எழுத்துப்பூர்வமாக தகவல் சொல்லுங்கள்
3. Admin Office-ற்கு செல்லுங்கள் (முதன்மை கட்டடம், தாழ்வாரம்) கீழ்காணும் ஆவணங்களுடன்:
   - இழந்த ID பிரகடன படிவம் (Admin Counter-ல் கிடைக்கும்)
   - Class Incharge-ல் இருந்து எழுத்துப்பூர்வ அறிவிப்பு
   - HOD அனுமোதன கடிதம்
4. படிவத்தை சமர்ப்பிக்கவும் மற்றும் Cash Counter-ல் ₹250 கட்டணம் செலுத்துங்கள்
5. 15 நாட்கள் செல்லுபடியாகும் தற்காலிக ID ரசீது சேகரிக்கவும்
6. ரசீதுடன் Campus Security-ற்கு புகாரளியுங்கள்
7. 2-4 வேலை நாட்களுக்குப் பிறகு புதிய ID அட்டை சேகரிக்கவும்

📍 இடம்: Admin Office, முதன்மை கட்டடம், தாழ்வாரம்
📞 தொடர்பு: நீட்சி 105 (ID Desk)
⏰ நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM
⚠️ குறிப்பு: ID இல்லாமல் நீங்கள் கல்லூரி வாயிலில் நுழையத் தடுக்கப்படலாம்',
'2-4 working days', 250.00, 'Admin Office, Main Building, Ground Floor'),

-- Exam eligibility
(11, 6, 'English', 'exam_eligibility',
'write exam, exam procedure, exam eligibility, eligible to write exam, can i write exam, how to write exam, can i attend exam with low attendance',
'📚 Exam Eligibility Based on Attendance

Category A (Attendance ≥ 75%): ✅ ELIGIBLE
- Can write exam without any restrictions
- No additional fees required

Category B (Attendance 65-74%): ⚠️ ELIGIBLE WITH CONDONATION
- Can write exam with payment of Condonation Fee: ₹250 to  ₹500
- Fee must be paid 3 days before exam
- Payment Location: Visit our offical website

Category C (Attendance 50-64%): ❌ NOT ELIGIBLE
- Cannot write exam
- Must repeat the course next semester
- Contact HOD for re-registration

Category D (Attendance < 50%): ❌ NOT ELIGIBLE
- Must repeat entire course
- Complete re-registration required
- Consult Academic Advisor

📍 Condonation Payment Location: Admin Office, Main Building (IT BLOCK), Ground Floor
📞 Contact: Evening Office(Academics)
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM

💡 Tip: Maintain minimum 75% attendance to avoid complications',
NULL, 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(12, 6, 'Tamil', 'exam_eligibility',
'exam எழுத, exam eligibility, தேர்வு எழுதலாமா',
'📚 Attendance-ல் அடிப்படையாக தேர்வு தகுதி

Category A (Attendance ≥ 75%): ✅ தகுதி உள்ளது
- எந்தவொரு கட்டுப்பாடும் இல்லாமல் தேர்வு எழுதலாம்
- கூடுதல் கட்டணம் தேவைப்படுவதில்லை

Category B (Attendance 65-74%): ⚠️ CONDONATION உடன் தகுதி உள்ளது
- Condonation கட்டணம் செலுத்தி தேர்வு எழுதலாம்: ₹250
- தேர்வுக்கு 3 நாட்களுக்கு முன் கட்டணம் செலுத்த வேண்டும்
- செலுத்தும் இடம்: Admin Office, Cash Counter

Category C (Attendance 50-64%): ❌ தகுதி இல்லை
- தேர்வு எழுத முடியாது
- அடுத்த செமிஸ்டரில் பாடத்தை மீண்டும் படிக்க வேண்டும்
- HOD-ஐ தொடர்புகொண்டு மீண்டும் பதிவு செய்ய வேண்டும்

Category D (Attendance < 50%): ❌ தகுதி இல்லை
- முழு பாடத்தையும் மீண்டும் படிக்க வேண்டும்
- முழு மீண்டும் பதிவு தேவை
- Academic Advisor-ஐ பார்க்கவும்

📍 Condonation செலுத்தும் இடம்: Admin Office, முதன்மை கட்டடம், தாழ்வாரம்
📞 தொடர்பு: Evening Office (Academics)
⏰ நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM

💡 குறிப்பு: சிக்கல்களை தவிர்க்க குறைந்தபட்சம் 75% attendance வைத்திருங்கள்',
NULL, 250.00, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

-- TC discontinued
(13, 4, 'English', 'tc_discontinued',
'tc discontinued, tc for discontinued, discontinued tc, dropout tc, left course tc, drop out',
'📋 Transfer Certificate Procedure (Discontinued/Dropout Students)
Processing Time: 7-10 working days

Step-by-Step Process:
1. Contact your Department HOD with discontinuation letter
2. Visit Department Office and collect TC Application Form
3. Inform and get approval from:
   - Class Incharge
   - Department HOD (Signature & Stamp)
4. Get clearance from Library (Return all books - Book Counter)
5. If Hostel resident: Get clearance from Hostel Warden
6. Visit Admin Office with all documents:
   - TC Application Form
   - HOD Approval Letter
   - Library Clearance Certificate
   - Hostel Clearance (if applicable)
   - Original Admission Document
7. Pay any pending fees (if any)
8. Collect TC Certificate after 7-10 working days

💡 Important Notes:
- Submit reason for discontinuation (Academic/Personal/Financial/Health/Career/Other)
- Maintain proof of reason (Medical certificate for health issues, etc.)
- Dropout after 2 years requires additional approval

📍 Location: Admin Office, Main Building (IT BLOCK), Ground Floor
📞 Contact: Evening Office
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building(IT BLOCK), Ground Floor'),

(14, 4, 'Tamil', 'tc_discontinued',
'படிப்பை நிறுத்தினால் tc, discontinued tc, dropout tc, transfer certificate',
'📋 Transfer Certificate பெறும் நடைமுறை (நிறுத்திய/Dropout மாணவர்கள்)
செயல்படுத்தும் நேரம்: 7-10 வேலை நாட்கள்

படிப்படியான நடைமுறை:
1. நிறுத்தும் கடிதத்துடன் உங்கள் துறை HOD-ஐ தொடர்புகொள்ளுங்கள்
2. துறை அலுவலகத்திற்குச் சென்று TC விண்ணப்பப் படிவம் சேகரிக்கவும்
3. பின்வருவனவற்றிலிருந்து அனுமதி பெறுங்கள்:
   - Class Incharge
   - துறை HOD (கையொப்பம் மற்றும் முத்திரை)
4. நூலகத்திலிருந்து சரியாக்கல் பெறுங்கள் (அனைத்து புத்தகங்களை திருப்பி அளியுங்கள்)
5. விடுதி வாசியாக இருந்தால்: விடுதி வாரிய தலைவரிடமிருந்து சரியாக்கல் பெறுங்கள்
6. அனைத்து ஆவணங்களுடன் Admin Office-ற்குச் செல்லுங்கள்:
   - TC விண்ணப்பப் படிவம்
   - HOD அனுமোதன கடிதம்
   - நூலக சரியாக்கல் சான்றிதழ்
   - விடுதி சரியாக்கல் (பொருந்தினால்)
   - அசல் சேர்க்கை ஆவணம்
7. நிலுவைக் கட்டணம் செலுத்துங்கள் (ஏதேனும் இருந்தால்)
8. 7-10 வேலை நாட்களுக்குப் பிறகு TC சான்றிதழ் சேகரிக்கவும்

💡 முக்கிய குறிப்புகள்:
- நிறுத்தும் காரணம் சமர்ப்பிக்கவும் (கல்வி/தனிப்பட்ட/நிதி/ஆரோக்கியம்/வேலை/மற்றவை)
- காரணத்தின் சான்று வைத்திருக்கவும் (ஆரோக்கியம் சம்பந்தப்பட்ட பிரச்சினைக்கு மருத்துவ சான்றிதழ் போன்றவை)
- 2 ஆண்டுகளுக்குப் பிறகு dropout பெறுவதற்கு கூடுதல் அனுமோதन தேவை

📍 இடம்: Admin Office, முதன்மை கட்டடம், தாழ்வாரம்
📞 தொடர்பு:Evening Office
⏰ நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM',
'7-10 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

-- General bonafide
(15, 4, 'English', 'bonafide_general',
'general bonafide certificate, general bonafide, student bonafide',
'📜 General Bonafide Certificate
Processing Time: 2-3 working days
Fee: FREE

Purpose:
- Proof that you are a bonafide student of the college
- Required for various government scholarships
- Needed for educational loans from banks
- Used for visa applications

Step-by-Step Procedure:
1. Visit Admin Office (Main Building (IT BLOCK), Ground Floor)
2. Collect General Bonafide Request Form through the class incharge
3. Fill in your registration number, name, department, and year
4. Visit Department  and get:
   - Class Incharge signature
   - Department seal/stamp
5. Visit College Union Office and get signature
6. Return to Admin Office with completed form
7. Submit to Evening Office
8. Collect certificate after 2-3 working days

Required Documents:
- Valid ID Card (or Provisional ID)
- Filled Bonafide Form
- Department & Union seals

📍 Location: Admin Office, Main Building (IT BLOCK), Ground Floor
📞 Contact: Evening Block (Certificates Desk)
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM
💡 No fees required - This is a basic service provided to all students',
'2-3 working days', NULL, 'Admin Office, Main Building, Ground Floor'),

-- Course bonafide
(16, 4, 'English', 'course_bonafide',
'course bonafide',
'📜 Course Bonafide Certificate
Processing Time: 3-4 working days
Fee: FREE

Purpose:
- Verification of your current course enrollment
- Required for semester admissions
- Proof of ongoing studies

Procedure:
1. Visit Admin Office (Main Building (IT BLOCK), Ground Floor)
2. Fill Course Bonafide Request Form
3. Provide:
   - Current semester details
   - Registration number
   - Course code and course name
4. Admin staff will verify enrollment in system
5. Collect certificate after 3-4 working days

Required Documents:
- Valid ID Card
- Filled Request Form

📍 Location: Admin Office, Main Building (IT BLOCK), Ground Floor
📞 Contact: Evening Office (Academics Desk)
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM',
'3-4 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

-- Passport bonafide
(17, 4, 'English', 'passport_bonafide',
'passport bonafide',
'📜 Passport Bonafide Certificate
Processing Time: 2-3 working days
Fee: ₹50

Purpose:
- Mandatory for Indian passport applications
- Accepted by Ministry of External Affairs
- Required proof of student status for passport

Procedure:
1. Visit Admin Office (Main Building (IT BLOCK), Ground Floor)
2. Collect Passport Bonafide Request Form
3. Fill form with:
   - Full name (as per documents)
   - Date of birth
   - Registration number
   - Current semester/year
4. Attach photocopy of:
   - Valid ID Card
   - Admission Document
5. Pay ₹50 fee at Cash Counter
6. Submit form to Certificates Desk
7. Collect certificate after 2-3 working days

Payment Details:
- Cash/Check accepted at Admin Office Cash Counter
- Fee receipt will be provided

Important Notes:
- Ensure name matches your government ID
- Certificate validity: 1 year from issue date
- Used only for passport applications

📍 Location: Admin Office, Main Building (IT BLOCK), Ground Floor
📞 Contact: Evening Office (Certificates Desk)
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM',
'2-3 working days', 50.00, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

-- Bonafide without fee
(18, 4, 'English', 'bonafide_without_fee',
'bonafide without fee, bonafide without fee payment, no fee bonafide',
'📜 Bonafide Without Fee Payment
Processing Time: 3-5 working days (with approval)
Fee: FREE (only with special permission)

Eligibility:
- Proven financial hardship (Below Poverty Line, etc.)
- Orphaned students
- Single parent family
- Students receiving scholarship
- Exceptional cases approved by Principal

Required Documents:
1. Bonafide Request Letter (explain reason for waiver)
2. Proof of financial condition:
   - BPL Certificate (if available)
   - Parent''s income proof
   - Affidavit on behalf of Principal
3. Valid ID Card
4. Admission Document

Approval Process:
1. Submit application at Admin Office with all documents
2. Request forwarded to:
   - Class Incharge (verification)
   - HOD (approval)
   - Dean of Student Affairs
3. Final approval from Principal/Director
4. Once approved, certificate is issued FREE

Timeline:
- Verification: 2-3 days
- Approval: 1-2 days
- Certificate issuance: 1 day

⚠️ Important Notes:
- Approval is NOT automatic - must provide valid justification
- Decision made on case-by-case basis
- Honorable reason required for waiver

📍 Location: Admin Office, Main Building (IT BLOCK), Ground Floor
📞 Contact: Evening Office (Special Cases)
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM',
'3-5 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

-- Marksheet lost
(21, 4, 'English', 'marksheet_lost',
'marksheet lost, lost marksheet, my marksheet is lost, certificate lost, duplicate marksheet',
'📄 Duplicate Marksheet/Certificate Procedure
Processing Time: 10-15 working days

Fee Structure (Based on Year Gap):
- 1 year gap: ₹1,000
- 2 year gap: ₹2,000
- 3 year gap: ₹3,000
- 4 year gap: ₹4,000
- 5 year gap: ₹5,000
- After 5 years: Request sent to University (Processing: 4-6 weeks)

Step-by-Step Process:
1. Visit Admin Office (Main Building (IT BLOCK), Ground Floor)
2. Collect Duplicate Certificate Request Form
3. Fill form with:
   - Semester/Year of exam
   - Subject codes and names
   - Exam registration number
4. Provide supporting documents:
   - Copy of original ID Card
   - Copy of Admission Document
   - Police FIR (if marked as lost/stolen)
5. Pay applicable fee at Cash Counter:
   - Processing fee: ₹100
   - Certificate duplication fee: ₹(based on year gap)
6. Submit completed form with receipts
7. Admin verifies details with University records
8. Duplicate certificate printed and issued

Important Notes:
- Official government certification from University
- Valid only as official proof
- Cannot replace original for certain legal purposes
- Service not available if gap exceeds 5 years (Direct University contact required)

📍 Location: Admin Office, Main Building (IT BLOCK), Ground Floor
📞 Contact: Extension 105 (Records Desk)
⏰ Hours: Mon-Fri, 9:00 AM - 4:30 PM',
'10-15 working days', NULL, 'Admin Office, Main Building (IT BLOCK), Ground Floor'),

(22, 4, 'Tamil', 'marksheet_lost',
'மார்க்ஷீட் தொலைந்தது, marksheet lost, certificate lost, duplicate marksheet',
'📄 Duplicate மார்க்ஷீட்/சான்றிதழ் பெறும் நடைமுறை
செயல்படுத்தும் நேரம்: 10-15 வேலை நாட்கள்

கட்டணம் (ஆண்டு இடைவெளிக்கு அடிப்படையாக):
- 1 ஆண்டு இடைவெளி: ₹1,000
- 2 ஆண்டு இடைவெளி: ₹2,000
- 3 ஆண்டு இடைவெளி: ₹3,000
- 4 ஆண்டு இடைவெளி: ₹4,000
- 5 ஆண்டு இடைவெளி: ₹5,000
- 5 ஆண்டுகளுக்குப் பிறகு: பல்கலைக்கழகத்திற்கு கோரிக்கை (செயல்படுத்தும் நேரம்: 4-6 வாரங்கள்)

படிப்படியான நடைமுறை:
1. Admin Office-ற்குச் செல்லுங்கள் (முதன்மை கட்டடம், தாழ்வாரம்)
2. Duplicate சான்றிதழ் கோரிக்கைப் படிவம் சேகரிக்கவும்
3. படிவத்தில் நிரப்பிக்கவும்:
   - செமிஸ்டர்/தேர்வு ஆண்டு
   - பாடப் குறியீடுகள் மற்றும் பெயர்கள்
   - தேர்வு பதிவு எண்
4. ஆதார ஆவணங்கள் வழங்குங்கள்:
   - அசல் ID அட்டையின் நகல்
   - சேர்க்கை ஆவணத்தின் நகல்
   - போலீஸ் FIR (தொலைந்தது/திருடப்பட்ட என்று குறித்தால்)
5. Cash Counter-ல் பொருந்தக்கூடிய கட்டணம் செலுத்துங்கள்:
   - செயல்படுத்தும் கட்டணம்: ₹100
   - சான்றிதழ் duplicate கட்டணம்: ₹(ஆண்டு இடைவெளிக்கு அடிப்படையாக)
6. ரசீதுகளுடன் முடிந்த படிவம் சமர்ப்பிக்கவும்
7. நிர்வாகம் பல்கலைக்கழக பதிவுகளுடன் விவரங்களை சரிபார்க்கும்
8. Duplicate சான்றிதழ் அச்சிடப்பட்டு வெளியீடு செய்யப்படும்

முக்கிய குறிப்புகள்:
- அரசாங்க சரிசெய்தல் பல்கலைக்கழகத்திலிருந்து
- அதிகாரப்பூர்வ சான்றாக மட்டுமே செல்லுபடியாகும்
- சில சட்ட நோக்கங்களுக்கு அசலைக் குறிக்கக்குறிக்க முடியாது
- 5 ஆண்டுகளுக்கு மேல் இடைவெளி இருந்தால் சேவை கிடைக்காது (நேரடி பல்கலைக்கழக தொடர்பு தேவை)

📍 இடம்: Admin Office, முதன்மை கட்டடம், தாழ்வாரம்
📞 தொடர்பு:Evening Office (Records Desk)
⏰ நேரம்: திங்கட்கிழமை-வெள்ளிக்கிழமை, 9:00 AM - 4:30 PM');

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

(1, 2, 'English', 'Semester Fee', 'Annual fee per semester', 'visit our website for more details', 'Due on registration', FALSE, TRUE, 'Before semester starts', 'Finance Office, refer admin office'),
(2, 2, 'English', 'Late Fee', 'Fine applicable after due date (₹500 per day)', 500.00, 'Fine Applicable', TRUE, FALSE, '7 days after due date', 'Finance Office'),
(3, 2, 'English', 'Hostel Fee', 'Annual hostel charges for residents', 30000.00, 'Payable once a year', FALSE, FALSE, 'Before hostel registration', 'Hostel Office'),
(4, 2, 'Tamil', 'செமிஸ்டர் கட்டணம்', 'ஒரு செமிஸ்டருக்கு ஆண்டு கட்டணம்','visit our website for more details' , 'பதிவுக்கு முன் செலுத்த வேண்டும்', FALSE, TRUE, 'செமிஸ்டர் தொடங்குவதற்கு முன்', 'Finance Office, Block-B'),
(5, 2, 'Tamil', 'தாமத கட்டணம்', 'கட்டணத்தின் கடைசி தேதிக்குப் பிறகு அபராதம் (₹500 நாளொன்றுக்கு)', 500.00, 'அபராதம் பொருந்தும்', TRUE, FALSE, 'கடைசி தேதிக்கு 7 நாட்களுக்குப் பிறகு', 'Finance Office'),
(6, 3, 'English', 'Medical Leave', 'Medical certificate required for absence', NULL, 'Medical Certificate Required', FALSE, FALSE, 'Within 3 days of return', 'Department '),
(7, 3, 'Tamil', 'மருத்துவ விடுப்பு', 'விடுப்புக்கு மருத்துவச் சான்றிதழ் தேவை', NULL, 'மருத்துவச் சான்றிதழ் அவசியம்', FALSE, FALSE, 'திரும்பிய 3 நாட்களுக்குள்', 'Department '),
(7, 4, 'English', 'Transfer Certificate', 'Students must complete department and office clearance before receiving TC.', NULL, 'Clearance Required (7-10 days)', FALSE, FALSE, 'Immediate', 'Department & Admin Office'),
(8, 4, 'Tamil', 'மாற்றுச் சான்றிதழ்', 'TC பெற துறை மற்றும் அலுவலக clearance முடிக்க வேண்டும்.', NULL, 'Clearance அவசியம் (7-10 நாட்கள்)', FALSE, FALSE, 'உடனடியாக', 'Department & Admin Office'),
(9, 6, 'English', 'Attendance Requirement', 'Minimum 75% attendance required to write exam', 75, 'Minimum 75%', FALSE, FALSE, NULL, 'Department & Admin Office'),
(10, 6, 'English', 'Condonation Fee', 'Condonation fee for 65-74% attendance', 250.00, '₹250 condonation fee', TRUE, FALSE, '3 days before exam', 'Admin Office, Cash Counter'),
(11, 6, 'Tamil', 'Attendance Requirement', 'தேர்வு எழுத குறைந்தபட்சம் 75% attendance தேவை', 75, 'குறைந்தபட்சம் 75%', FALSE, FALSE, NULL, 'Department & Admin Office');

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
