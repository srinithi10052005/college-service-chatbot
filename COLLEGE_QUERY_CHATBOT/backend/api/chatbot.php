<?php
// 1. Connect to DB and set headers FIRST
include("../config/db.php");
header("Content-Type: application/json; charset=UTF-8");

// ✅ Check DB connection immediately
if ($conn->connect_error) {
    echo json_encode(["reply" => "DB connection failed: " . $conn->connect_error]);
    exit;
}

function sendReply($message) {
    echo json_encode(["reply" => $message], JSON_UNESCAPED_UNICODE);
    exit;
}

function normalizeText($text) {
    $text = trim($text);
    $text = mb_strtolower($text, 'UTF-8');
    $text = preg_replace('/\s+/', ' ', $text);
    return $text;
}

function detectLanguage($text) {
    return preg_match('/[\x{0B80}-\x{0BFF}]/u', $text) ? "Tamil" : "English";
}

/* =========================
   FUZZY MATCHING FUNCTION
   ========================= */
function fuzzyMatch($input, $keyword, $threshold = 0.75) {
    $input   = mb_strtolower($input,   'UTF-8');
    $keyword = mb_strtolower($keyword, 'UTF-8');

    if ($input === $keyword) return 1.0;

    if (strpos($input, $keyword) !== false || strpos($keyword, $input) !== false) return 0.95;

    $similarity = 0;
    similar_text($input, $keyword, $similarity);
    $similarity = $similarity / 100;

    if ($similarity >= $threshold) return $similarity;

    if (soundex($input) === soundex($keyword)) return 0.85;

    return 0;
}

/* =========================
   IMPROVED KEYWORD SEARCH
   ========================= */
function findBestMatch($input, $keywords, $threshold = 0.75) {
    $bestMatch = null;
    $bestScore = 0;

    $keywordArray = array_map('trim', preg_split('/,|\n/', $keywords));

    foreach ($keywordArray as $keyword) {
        if (empty($keyword)) continue;

        $score = fuzzyMatch($input, $keyword, $threshold);

        if ($score > $bestScore) {
            $bestScore = $score;
            $bestMatch = $keyword;
        }
    }

    return ($bestScore >= $threshold) ? $bestMatch : null;
}

// ✅ Safe prepare helper — returns false and logs error if prepare fails
function safePrepare($conn, $sql) {
    $stmt = $conn->prepare($sql);
    if ($stmt === false) {
        error_log("MySQL prepare failed: " . $conn->error . " | SQL: " . $sql);
    }
    return $stmt;
}

// Read incoming data
$raw  = file_get_contents("php://input");
$data = json_decode($raw, true);

if (!$data) {
    $data = $_POST;
}

$message  = trim($data["message"]  ?? "");
$language = trim($data["language"] ?? "");

if ($message === "") {
    sendReply("Please type your question.");
}

if ($language === "") {
    $language = detectLanguage($message);
}

$normalized = normalizeText($message);

/* =========================
   1) Greeting
   ========================= */
$englishGreetings = ["hi", "hello", "hey", "good morning", "good afternoon", "good evening"];
$tamilGreetings   = ["வணக்கம்", "ஹாய்", "ஹலோ", "காலை வணக்கம்", "மாலை வணக்கம்"];

if (in_array($normalized, $englishGreetings, true)) {
    sendReply("👋 Welcome to SDNB ASKNOVA. I am your service assistant. Ask me about bonafide, outpass, TC, attendance, missing ID, missing TC, MOI, or services.");
}

if (in_array($message, $tamilGreetings, true)) {
    sendReply("👋 SDNB ASKNOVA-க்கு வரவேற்கிறோம். bonafide, outpass, TC, attendance, missing ID, missing TC, MOI, services பற்றி கேட்கலாம்.");
}

/* =========================
   2) Admin-service aliases
   ========================= */
$serviceAliases = [
    "food facility"                  => "Subsidized Food",
    "food service"                   => "Subsidized Food",
    "canteen food"                   => "Subsidized Food",
    "cheap food"                     => "Subsidized Food",
    "subsidized food"                => "Subsidized Food",
    "napkin"                         => "Napkin Service",
    "napkin service"                 => "Napkin Service",
    "attendance certificate"         => "Attendance Certificate",
    "scholarship"                    => "Scholarship Form",
    "scholarship form"               => "Scholarship Form",
    "fee structure"                  => "Fee Structure Certificate",
    "fee structure certificate"      => "Fee Structure Certificate",
    "lost id card"                   => "Lost ID Card",
    "complaint"                      => "Complaint Service",
    "missing items"                  => "Missing Items Report",
    "single parent support"          => "Single Parent Support",
    "transfer certificate"           => "Passout / Dropout",
    "tranfer certificate"            => "Passout / Dropout",
    "physically challenged support"  => "Physically Challenged Support"
];

foreach ($serviceAliases as $alias => $serviceName) {
    if (fuzzyMatch($normalized, $alias, 0.75) > 0.75) {
        $stmt = safePrepare($conn, "
            SELECT service_name, issued_by, purpose, requirements, fees
            FROM admin_services
            WHERE service_name = ?
            LIMIT 1
        ");

        if ($stmt) {
            $stmt->bind_param("s", $serviceName);
            $stmt->execute();
            $res = $stmt->get_result();

            if ($row = $res->fetch_assoc()) {
                $reply = "Service: " . $row["service_name"] . "\n";
                if (!empty($row["issued_by"]))    $reply .= "Issued By: "    . $row["issued_by"]    . "\n";
                if (!empty($row["purpose"]))      $reply .= "Purpose: "      . $row["purpose"]      . "\n";
                if (!empty($row["requirements"])) $reply .= "Requirements: " . $row["requirements"] . "\n";
                if (!is_null($row["fees"]))       $reply .= "Fees: Rs."      . number_format((float)$row["fees"], 2) . "\n";
                sendReply(trim($reply));
            }
        }
    }
}

/* =========================
   3) Condonation fee
   ========================= */
if (
    fuzzyMatch($normalized, "condonation fee",              0.75) > 0.75 ||
    fuzzyMatch($normalized, "attendance condonation fee",   0.75) > 0.75 ||
    fuzzyMatch($normalized, "low attendance fee",           0.75) > 0.75 ||
    fuzzyMatch($normalized, "fee for attendance shortage",  0.75) > 0.75
) {
    if ($language === "Tamil") {
        sendReply("65% முதல் 74% வரை attendance உள்ளவர்கள் ரூ.250 condonation fee செலுத்த வேண்டும்.");
    } else {
        sendReply("Students with attendance between 65% and 74% must pay a condonation fee of Rs.250.");
    }
}

/* =========================
   4) Attendance percentage
   ========================= */
if (
    preg_match('/(\d+)\s*%/u',           $normalized, $m) ||
    preg_match('/attendance\s*(\d+)/u',  $normalized, $m) ||
    preg_match('/(\d+)\s*attendance/u',  $normalized, $m)
) {
    $percent = (int)$m[1];

    $stmt = safePrepare($conn, "
        SELECT category_code, title, response
        FROM attendance_categories
        WHERE language = ?
          AND ? BETWEEN min_percent AND max_percent
        LIMIT 1
    ");

    if ($stmt) {
        $stmt->bind_param("si", $language, $percent);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            $reply  = "Attendance: {$percent}%\n";
            $reply .= $row["title"] . " (" . $row["category_code"] . ")\n";
            $reply .= $row["response"];
            sendReply($reply);
        }
    }
}

/* =========================
   5) Attendance rules / exam eligibility
   ========================= */
$examKeywords = [
    "attendance rules", "minimum attendance", "required attendance",
    "can i write exam", "write the exam", "how to write exam",
    "exam procedure", "exam eligibility", "can i attend exam with low attendance"
];

$isExamQuery = false;
foreach ($examKeywords as $keyword) {
    if (fuzzyMatch($normalized, $keyword, 0.75) > 0.75) {
        $isExamQuery = true;
        break;
    }
}

if ($isExamQuery ||
    (fuzzyMatch($normalized, "attendance", 0.75) > 0.75 &&
     fuzzyMatch($normalized, "attendance certificate", 0.75) <= 0.75)) {

    $stmt = safePrepare($conn, "
        SELECT category_code, title, response
        FROM attendance_categories
        WHERE language = ?
        ORDER BY min_percent DESC
    ");

    if ($stmt) {
        $stmt->bind_param("s", $language);
        $stmt->execute();
        $res = $stmt->get_result();

        $parts = [];
        while ($row = $res->fetch_assoc()) {
            $parts[] = $row["title"] . " (" . $row["category_code"] . "): " . $row["response"];
        }

        if (!empty($parts)) {
            sendReply(implode("\n\n", $parts));
        }
    }
}

/* =========================
   6) Missing TC / marksheet with year gap
   ========================= */
$tcKeywords = [
    "missing tc", "missing marksheet", "marksheet lost",
    "lost marksheet", "duplicate certificate", "duplicate certificates"
];

$hasTcKeyword = false;
foreach ($tcKeywords as $keyword) {
    if (fuzzyMatch($normalized, $keyword, 0.75) > 0.75) {
        $hasTcKeyword = true;
        break;
    }
}

if ($hasTcKeyword && preg_match('/(\d+)\s*year/u', $normalized, $m)) {
    $yearGap = (int)$m[1];

    $stmt = safePrepare($conn, "
        SELECT topic, purpose, year_gap, amount
        FROM student_requests
        WHERE topic LIKE ? AND year_gap = ?
        LIMIT 1
    ");

    if ($stmt) {
        $topicPattern = "%Duplicate%";
        $stmt->bind_param("si", $topicPattern, $yearGap);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            $reply = "📄 " . $row["topic"] . "\n";
            if (!empty($row["purpose"]))    $reply .= "Purpose: "  . $row["purpose"]  . "\n";
            if (!is_null($row["year_gap"])) $reply .= "Year Gap: " . $row["year_gap"] . "\n";
            if (!is_null($row["amount"]))   $reply .= "Amount: Rs." . number_format((float)$row["amount"], 2) . "\n";
            sendReply(trim($reply));
        }
    }
}

/* =========================
   7A) Dropout — Step A
   ========================= */
if (fuzzyMatch($normalized, "dropout",   0.75) > 0.75 &&
    fuzzyMatch($normalized, "reason",    0.75) <= 0.75 &&
    fuzzyMatch($normalized, "academic",  0.75) <= 0.75 &&
    fuzzyMatch($normalized, "personal",  0.75) <= 0.75 &&
    fuzzyMatch($normalized, "financial", 0.75) <= 0.75 &&
    fuzzyMatch($normalized, "health",    0.75) <= 0.75 &&
    fuzzyMatch($normalized, "career",    0.75) <= 0.75) {

    $reply  = "📋 Dropout Request\n\n";
    $reply .= "Please select the reason category for dropout:\n\n";
    $reply .= "1️⃣  Academic\n";
    $reply .= "2️⃣  Personal / Family\n";
    $reply .= "3️⃣  Financial\n";
    $reply .= "4️⃣  Health\n";
    $reply .= "5️⃣  Career / Opportunity\n";
    $reply .= "6️⃣  Other\n\n";
    $reply .= "👉 Type: dropout academic  (or) dropout financial  (or) dropout health  etc.";
    sendReply($reply);
}

/* =========================
   7B) Dropout — Step B
   ========================= */
$categoryMap = [
    "academic"    => "Academic",
    "personal"    => "Personal",
    "family"      => "Personal",
    "financial"   => "Financial",
    "health"      => "Health",
    "career"      => "Career",
    "opportunity" => "Career",
    "other"       => "Other",
    "others"      => "Other"
];

foreach ($categoryMap as $keyword => $dbCategory) {
    $keywordScore  = fuzzyMatch($normalized, $keyword,            0.70);
    $dropoutScore  = fuzzyMatch($normalized, "dropout " . $keyword, 0.70);
    $reasonScore   = fuzzyMatch($normalized, "reason",            0.70);

    if (($keywordScore > 0.70 || $dropoutScore > 0.70) && $reasonScore <= 0.70) {
        $stmt = safePrepare($conn, "
            SELECT reason_code, reason_text, reason_tamil
            FROM dropout_reasons
            WHERE category = ?
            ORDER BY reason_code ASC
        ");

        if ($stmt) {
            $stmt->bind_param("s", $dbCategory);
            $stmt->execute();
            $res = $stmt->get_result();

            if ($res && $res->num_rows > 0) {
                $reply  = "📋 Dropout — {$dbCategory} Reasons\n\n";
                $reply .= "Please type the reason code that applies:\n\n";

                while ($row = $res->fetch_assoc()) {
                    $reply .= "• [{$row['reason_code']}] {$row['reason_text']}\n";
                    if ($language === "Tamil" && !empty($row["reason_tamil"])) {
                        $reply .= "        ({$row['reason_tamil']})\n";
                    }
                }

                $reply .= "\n👉 Type the code, e.g.: dropout reason " . ($dbCategory === 'Other' ? 'OT02' : 'AC01');
                sendReply($reply);
            }
        }
        break;
    }
}

/* =========================
   7C) Dropout — Step C
   ========================= */
if (preg_match('/([A-Za-z]{2}\d{2})/u', $message, $codeMatch)) {
    $code = strtoupper($codeMatch[1]);

    $stmt = safePrepare($conn, "
        SELECT category, reason_text, reason_tamil
        FROM dropout_reasons
        WHERE reason_code = ?
        LIMIT 1
    ");

    if ($stmt) {
        $stmt->bind_param("s", $code);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            $category      = $row["category"];
            $reasonDisplay = ($language === "Tamil" && !empty($row["reason_tamil"]))
                ? $row["reason_text"] . " (" . $row["reason_tamil"] . ")"
                : $row["reason_text"];

            $reply  = "✅ Dropout Reason Recorded\n\n";
            $reply .= "Category : " . $category      . "\n";
            $reply .= "Reason   : " . $reasonDisplay . "\n\n";
            $reply .= "📌 Next steps for " . $category . ":\n";

            switch ($category) {
                case 'Academic':
                    $reply .= "1. Obtain a 'No Objection' letter from your HOD.\n";
                    $reply .= "2. Return all issued library books and settle fines.\n";
                    break;
                case 'Career':
                    $reply .= "1. Submit a copy of your appointment order/exam selection letter.\n";
                    $reply .= "2. Visit the Placement Cell for a clearance signature.\n";
                    break;
                case 'Health':
                    $reply .= "1. Attach an original Medical Certificate from a Govt. Doctor.\n";
                    $reply .= "2. Get the withdrawal form signed by the College Doctor/HOD.\n";
                    break;
                case 'Financial':
                    $reply .= "1. Visit the Accounts Section to verify pending fees.\n";
                    $reply .= "2. Submit a formal letter regarding financial hardship.\n";
                    break;
                default:
                    $reply .= "1. Visit the Admin Office with your department letter.\n";
                    $reply .= "2. Mention the year of discontinuation.\n";
            }

            $reply .= "3. Submit the final dropout form to the Principal's office.\n";
            $reply .= "4. Collect your Transfer Certificate (TC) after 3 working days.\n\n";
            $reply .= "Need more help? Ask about TC, bonafide, or services.";

            sendReply($reply);
        } else {
            sendReply("⚠️ Invalid reason code '{$code}'. Please type a valid code like AC01, PE01, FI02 etc.");
        }
    }
}

/* =========================
   7D) Student request special topics
   ========================= */
$studentTopics = [
    "moi"                       => "Medium of Instruction (MOI)",
    "medium of instruction"     => "Medium of Instruction (MOI)",
    "genuineness certificate"   => "Genuineness Certificate",
    "disability"                => "Disability Student Exemption",
    "physically challenged"     => "Disability Student Exemption"
];

foreach ($studentTopics as $key => $topicName) {
    if (fuzzyMatch($normalized, $key, 0.75) > 0.75) {
        $stmt = safePrepare($conn, "
            SELECT topic, year_of_discontinuation, reason, purpose, year_gap, amount
            FROM student_requests
            WHERE topic = ?
            LIMIT 1
        ");

        if ($stmt) {
            $stmt->bind_param("s", $topicName);
            $stmt->execute();
            $res = $stmt->get_result();

            if ($row = $res->fetch_assoc()) {
                $reply = "📄 " . $row["topic"] . "\n";
                if (!empty($row["year_of_discontinuation"])) $reply .= "Year of Discontinuation: " . $row["year_of_discontinuation"] . "\n";
                if (!empty($row["reason"]))   $reply .= "Reason: "   . $row["reason"]   . "\n";
                if (!empty($row["purpose"]))  $reply .= "Purpose: "  . $row["purpose"]  . "\n";
                if (!is_null($row["year_gap"])) $reply .= "Year Gap: " . $row["year_gap"] . "\n";
                if (!is_null($row["amount"]))   $reply .= "Amount: Rs." . number_format((float)$row["amount"], 2) . "\n";
                sendReply(trim($reply));
            }
        }
    }
}

/* =========================
   8) Missing TC / marksheet general
   ========================= */
if ($hasTcKeyword) {
    $stmt = safePrepare($conn, "
        SELECT year_gap, amount
        FROM student_requests
        WHERE topic LIKE ?
        ORDER BY year_gap ASC
    ");

    if ($stmt) {
        $pattern = "%Duplicate%";
        $stmt->bind_param("s", $pattern);
        $stmt->execute();
        $res = $stmt->get_result();

        $lines = ["📄 Missing TC / Marksheets", "Charges based on year gap:"];
        while ($row = $res->fetch_assoc()) {
            if (!is_null($row["year_gap"]) && !is_null($row["amount"])) {
                $lines[] = $row["year_gap"] . " year gap: Rs." . number_format((float)$row["amount"], 2);
            }
        }

        sendReply(implode("\n", $lines));
    }
}

/* =========================
   9) Cross-language chatbot intents
   ========================= */
$allMatches = [];

$res = $conn->query("SELECT intent_name, keywords FROM chatbot_intents");

if ($res === false) {
    error_log("Query failed (chatbot_intents): " . $conn->error);
} else {
    while ($row = $res->fetch_assoc()) {
        $keywordsRaw = trim($row["keywords"]);
        if ($keywordsRaw === "") continue;

        $bestKeyword = findBestMatch($normalized, $keywordsRaw, 0.70);

        if ($bestKeyword !== null) {
            $score = fuzzyMatch($normalized, $bestKeyword, 0.70);
            $allMatches[] = [
                "keyword"     => $bestKeyword,
                "length"      => mb_strlen($bestKeyword, 'UTF-8'),
                "score"       => $score,
                "intent_name" => $row["intent_name"]
            ];
        }
    }
}

if (!empty($allMatches)) {
    usort($allMatches, function($a, $b) {
        if ($b["score"] !== $a["score"]) {
            return $b["score"] <=> $a["score"];
        }
        return $b["length"] <=> $a["length"];
    });

    $matchedIntent = $allMatches[0]["intent_name"];

    $stmt = safePrepare($conn, "
        SELECT response
        FROM chatbot_intents
        WHERE intent_name = ? AND language = ?
        LIMIT 1
    ");

    if ($stmt) {
        $stmt->bind_param("ss", $matchedIntent, $language);
        $stmt->execute();
        $targetRes = $stmt->get_result();

        if ($targetRow = $targetRes->fetch_assoc()) {
            sendReply($targetRow["response"]);
        }
    }
}

/* =========================
   10) Admin services list
   ========================= */
$servicesKeywords = [
    "services", "service", "available services", "available service",
    "admin services", "what services available", "student services"
];

$isServicesQuery = false;
foreach ($servicesKeywords as $keyword) {
    if (fuzzyMatch($normalized, $keyword, 0.75) > 0.75) {
        $isServicesQuery = true;
        break;
    }
}

if ($isServicesQuery) {
    $res = $conn->query("SELECT service_name FROM admin_services ORDER BY id ASC");

    if ($res === false) {
        error_log("Query failed (admin_services list): " . $conn->error);
    } else {
        $services = [];
        while ($row = $res->fetch_assoc()) {
            $services[] = $row["service_name"];
        }

        if (!empty($services)) {
            $formatted = "Available services:\n\n";
            foreach ($services as $index => $service) {
                $formatted .= ($index + 1) . ". " . $service . "\n";
            }
            sendReply(trim($formatted));
        }
    }
}

/* =========================
   11) Admin services direct-name lookup
   ========================= */
$res = $conn->query("SELECT service_name, issued_by, purpose, requirements, fees FROM admin_services");

if ($res === false) {
    error_log("Query failed (admin_services lookup): " . $conn->error);
} else {
    while ($row = $res->fetch_assoc()) {
        $service = mb_strtolower($row["service_name"], 'UTF-8');
        $score   = fuzzyMatch($normalized, $service, 0.70);

        if ($score > 0.70) {
            $reply = "Service: " . $row["service_name"] . "\n";
            if (!empty($row["issued_by"]))    $reply .= "Issued By: "    . $row["issued_by"]    . "\n";
            if (!empty($row["purpose"]))      $reply .= "Purpose: "      . $row["purpose"]      . "\n";
            if (!empty($row["requirements"])) $reply .= "Requirements: " . $row["requirements"] . "\n";
            if (!is_null($row["fees"]))       $reply .= "Fees: Rs."      . number_format((float)$row["fees"], 2) . "\n";
            sendReply(trim($reply));
        }
    }
}

/* =========================
   12) Policies fallback
   ========================= */
$stmt = safePrepare($conn, "
    SELECT policy_title, policy_description, value_text, fine_applicable, installment_allowed
    FROM policies
    WHERE language = ?
");

if ($stmt) {
    $stmt->bind_param("s", $language);
    $stmt->execute();
    $res = $stmt->get_result();

    while ($row = $res->fetch_assoc()) {
        $title = mb_strtolower($row["policy_title"], 'UTF-8');
        $score = fuzzyMatch($normalized, $title, 0.70);

        if ($score > 0.70) {
            $reply = $row["policy_title"] . "\n" . $row["policy_description"];
            if (!empty($row["value_text"]))           $reply .= "\nInfo: "                 . $row["value_text"];
            if (!is_null($row["fine_applicable"]))    $reply .= "\nFine Applicable: "      . ($row["fine_applicable"]     ? "Yes" : "No");
            if (!is_null($row["installment_allowed"])) $reply .= "\nInstallment Allowed: " . ($row["installment_allowed"] ? "Yes" : "No");
            sendReply($reply);
        }
    }
}

/* =========================
   Year-only input hint
   ========================= */
if (preg_match('/^\d{4}$/', $normalized)) {
    sendReply("I noticed you entered a year ($normalized). If this is for a Dropout request, please ensure you have first provided a reason code (e.g., 'dropout reason AC01').");
}

/* =========================
   13) Final fallback
   ========================= */
if ($language === "Tamil") {
    sendReply("மன்னிக்கவும், இந்த கேள்விக்கான பதில் இல்லை. bonafide, outpass, TC, attendance, missing ID, missing TC, MOI, services பற்றி கேளுங்கள்.");
} else {
    sendReply("Sorry, I could not find an answer for that. Please ask about bonafide, outpass, TC, attendance, missing ID, missing TC, MOI, or services.");
}
?>
