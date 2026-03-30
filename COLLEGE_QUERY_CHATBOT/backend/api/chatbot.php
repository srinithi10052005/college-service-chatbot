<?php
include("../config/db.php");
header("Content-Type: application/json; charset=UTF-8");

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

$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

if (!$data) {
    $data = $_POST;
}

$message = trim($data["message"] ?? "");
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
   Exact-match only
   ========================= */
$englishGreetings = ["hi", "hello", "hey", "good morning", "good afternoon", "good evening"];
$tamilGreetings = ["வணக்கம்", "ஹாய்", "ஹலோ", "காலை வணக்கம்", "மாலை வணக்கம்"];

if (in_array($normalized, $englishGreetings, true)) {
    sendReply("👋 Welcome to SDNB ASKNOVA. I am your service assistant. Ask me about bonafide, outpass, TC, attendance, missing ID, missing TC, MOI, or services.");
}

if (in_array($message, $tamilGreetings, true)) {
    sendReply("👋 SDNB ASKNOVA-க்கு வரவேற்கிறோம். bonafide, outpass, TC, attendance, missing ID, missing TC, MOI, services பற்றி கேட்கலாம்.");
}

/* =========================
   2) Admin-service aliases
   Handle natural user wording early
   ========================= */
$serviceAliases = [
    "food facility" => "Subsidized Food",
    "food service" => "Subsidized Food",
    "canteen food" => "Subsidized Food",
    "cheap food" => "Subsidized Food",
    "subsidized food" => "Subsidized Food",
    "napkin" => "Napkin Service",
    "napkin service" => "Napkin Service",
    "attendance certificate" => "Attendance Certificate",
    "scholarship" => "Scholarship Form",
    "scholarship form" => "Scholarship Form",
    "fee structure" => "Fee Structure Certificate",
    "fee structure certificate" => "Fee Structure Certificate",
    "lost id card" => "Lost ID Card",
    "complaint" => "Complaint Service",
    "missing items" => "Missing Items Report",
    "single parent support" => "Single Parent Support",
    "continuous study" => "Continuous Study / Discontinuation",
    "physically challenged support" => "Physically Challenged Support"
];

foreach ($serviceAliases as $alias => $serviceName) {
    if (strpos($normalized, $alias) !== false) {
        $stmt = $conn->prepare("
            SELECT service_name, issued_by, purpose, requirements, fees, notes
            FROM admin_services
            WHERE service_name = ?
            LIMIT 1
        ");
        $stmt->bind_param("s", $serviceName);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            $reply = "Service: " . $row["service_name"] . "\n";

            if (!empty($row["issued_by"])) {
                $reply .= "Issued By: " . $row["issued_by"] . "\n";
            }
            if (!empty($row["purpose"])) {
                $reply .= "Purpose: " . $row["purpose"] . "\n";
            }
            if (!empty($row["requirements"])) {
                $reply .= "Requirements: " . $row["requirements"] . "\n";
            }
            if (!is_null($row["fees"])) {
                $reply .= "Fees: Rs." . number_format((float)$row["fees"], 2) . "\n";
            }
            if (!empty($row["notes"])) {
                $reply .= "Notes: " . $row["notes"];
            }

            sendReply(trim($reply));
        }
    }
}

/* =========================
   3A) Condonation fee
   ========================= */
if (
    strpos($normalized, "condonation fee") !== false ||
    strpos($normalized, "attendance condonation fee") !== false ||
    strpos($normalized, "low attendance fee") !== false ||
    strpos($normalized, "fee for attendance shortage") !== false
) {
    if ($language === "Tamil") {
        sendReply("65% முதல் 74% வரை attendance உள்ளவர்கள் ரூ.250 condonation fee செலுத்த வேண்டும்.");
    } else {
        sendReply("Students with attendance between 65% and 74% must pay a condonation fee of Rs.250.");
    }
}

/* =========================
   3) Attendance percentage
   ========================= */
if (
    preg_match('/(\d+)\s*%/u', $normalized, $m) ||
    preg_match('/attendance\s*(\d+)/u', $normalized, $m) ||
    preg_match('/(\d+)\s*attendance/u', $normalized, $m)
) {
    $percent = (int)$m[1];

    $stmt = $conn->prepare("
        SELECT category_code, title, response
        FROM attendance_categories
        WHERE language = ?
        AND ? BETWEEN min_percent AND max_percent
        LIMIT 1
    ");
    $stmt->bind_param("si", $language, $percent);
    $stmt->execute();
    $res = $stmt->get_result();

    if ($row = $res->fetch_assoc()) {
        $reply = "Attendance: {$percent}%\n";
        $reply .= $row["title"] . " (" . $row["category_code"] . ")\n";
        $reply .= $row["response"];
        sendReply($reply);
    }
}

/* =========================
   4) Condonation fee
   ========================= */
if (
    strpos($normalized, "condonation fee") !== false ||
    strpos($normalized, "attendance condonation fee") !== false ||
    strpos($normalized, "low attendance fee") !== false ||
    strpos($normalized, "fee for attendance shortage") !== false
) {
    if ($language === "Tamil") {
        sendReply("65% முதல் 74% வரை attendance உள்ளவர்கள் ரூ.250 condonation fee செலுத்த வேண்டும்.");
    } else {
        sendReply("Students with attendance between 65% and 74% must pay a condonation fee of Rs.250.");
    }
}

/* =========================
   5) Attendance rules / exam eligibility
   Avoid admin-service phrases here
   ========================= */
if (
    strpos($normalized, "attendance rules") !== false ||
    strpos($normalized, "minimum attendance") !== false ||
    strpos($normalized, "required attendance") !== false ||
    strpos($normalized, "can i write exam") !== false ||
    strpos($normalized, "write the exam") !== false ||
    strpos($normalized, "how to write exam") !== false ||
    strpos($normalized, "exam procedure") !== false ||
    strpos($normalized, "exam eligibility") !== false ||
    strpos($normalized, "can i attend exam with low attendance") !== false ||
    (
        strpos($normalized, "attendance") !== false &&
        strpos($normalized, "attendance certificate") === false
    )
) {
    $stmt = $conn->prepare("
        SELECT category_code, title, response
        FROM attendance_categories
        WHERE language = ?
        ORDER BY min_percent DESC
    ");
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

/* =========================
   6) Missing TC / marksheet with year gap
   ========================= */
if (
    (
        strpos($normalized, "missing tc") !== false ||
        strpos($normalized, "missing marksheet") !== false ||
        strpos($normalized, "marksheet lost") !== false ||
        strpos($normalized, "lost marksheet") !== false ||
        strpos($normalized, "duplicate certificate") !== false ||
        strpos($normalized, "duplicate certificates") !== false
    ) &&
    preg_match('/(\d+)\s*year/u', $normalized, $m)
) {
    $yearGap = (int)$m[1];

    $stmt = $conn->prepare("
        SELECT topic, purpose, year_gap, amount, notes
        FROM student_requests
        WHERE topic = 'Missing TC / Marksheets'
        AND year_gap = ?
        LIMIT 1
    ");
    $stmt->bind_param("i", $yearGap);
    $stmt->execute();
    $res = $stmt->get_result();

    if ($row = $res->fetch_assoc()) {
        $reply = "📄 " . $row["topic"] . "\n";

        if (!empty($row["purpose"])) {
            $reply .= "Purpose: " . $row["purpose"] . "\n";
        }
        if (!is_null($row["year_gap"])) {
            $reply .= "Year Gap: " . $row["year_gap"] . "\n";
        }
        if (!is_null($row["amount"])) {
            $reply .= "Amount: Rs." . number_format((float)$row["amount"], 2) . "\n";
        }
        if (!empty($row["notes"])) {
            $reply .= "Notes: " . $row["notes"];
        }

        sendReply(trim($reply));
    }
}

/* =========================
   7) Student request special topics
   ========================= */
$studentTopics = [
    "moi" => "Medium of Instruction (MOI)",
    "medium of instruction" => "Medium of Instruction (MOI)",
    "genuineness certificate" => "Genuineness Certificate",
    "dropout" => "Dropout",
    "disability" => "Disability Student Exemption",
    "physically challenged" => "Disability Student Exemption"
];

foreach ($studentTopics as $key => $topicName) {
    if (strpos($normalized, $key) !== false) {
        $stmt = $conn->prepare("
            SELECT topic, year_of_discontinuation, reason, purpose, year_gap, amount, notes
            FROM student_requests
            WHERE topic = ?
            LIMIT 1
        ");
        $stmt->bind_param("s", $topicName);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            $reply = "📄 " . $row["topic"] . "\n";

            if (!empty($row["year_of_discontinuation"])) {
                $reply .= "Year of Discontinuation: " . $row["year_of_discontinuation"] . "\n";
            }
            if (!empty($row["reason"])) {
                $reply .= "Reason: " . $row["reason"] . "\n";
            }
            if (!empty($row["purpose"])) {
                $reply .= "Purpose: " . $row["purpose"] . "\n";
            }
            if (!is_null($row["year_gap"])) {
                $reply .= "Year Gap: " . $row["year_gap"] . "\n";
            }
            if (!is_null($row["amount"])) {
                $reply .= "Amount: Rs." . number_format((float)$row["amount"], 2) . "\n";
            }
            if (!empty($row["notes"])) {
                $reply .= "Notes: " . $row["notes"];
            }

            sendReply(trim($reply));
        }
    }
}

/* =========================
   8) Missing TC / marksheet general
   ========================= */
if (
    strpos($normalized, "missing tc") !== false ||
    strpos($normalized, "missing marksheet") !== false ||
    strpos($normalized, "marksheet lost") !== false ||
    strpos($normalized, "lost marksheet") !== false ||
    strpos($normalized, "duplicate certificate") !== false ||
    strpos($normalized, "duplicate certificates") !== false
) {
    $stmt = $conn->prepare("
        SELECT year_gap, amount, notes
        FROM student_requests
        WHERE topic = 'Missing TC / Marksheets'
        ORDER BY year_gap ASC
    ");
    $stmt->execute();
    $res = $stmt->get_result();

    $lines = ["📄 Missing TC / Marksheets", "Charges based on year gap:"];

    while ($row = $res->fetch_assoc()) {
        if (!is_null($row["year_gap"]) && !is_null($row["amount"])) {
            $lines[] = $row["year_gap"] . " year gap: Rs." . number_format((float)$row["amount"], 2);
        } elseif (!empty($row["notes"])) {
            $lines[] = $row["notes"];
        }
    }

    sendReply(implode("\n", $lines));
}

/* =========================
   9) Chatbot intents
   Longest keyword match first
   ========================= */
$allMatches = [];

$res = $conn->query("
    SELECT language, intent_name, keywords, response
    FROM chatbot_intents
");

if ($res) {
    while ($row = $res->fetch_assoc()) {
        if ($row["language"] !== $language) {
            continue;
        }

        $keywordsRaw = trim($row["keywords"]);
        if ($keywordsRaw === "") {
            continue;
        }

        $keywords = preg_split('/,|\n/u', $keywordsRaw);

        foreach ($keywords as $keyword) {
            $keyword = trim(mb_strtolower($keyword, 'UTF-8'));
            if ($keyword === "") {
                continue;
            }

            if (strpos($normalized, $keyword) !== false) {
                $allMatches[] = [
                    "keyword" => $keyword,
                    "length" => mb_strlen($keyword, 'UTF-8'),
                    "response" => $row["response"],
                    "intent_name" => $row["intent_name"]
                ];
            }
        }
    }
}

if (!empty($allMatches)) {
    usort($allMatches, function($a, $b) {
        return $b["length"] <=> $a["length"];
    });

    sendReply($allMatches[0]["response"]);
}

/* =========================
   10) Admin services list
   ========================= */
if (
    strpos($normalized, "services") !== false ||
    strpos($normalized, "service") !== false ||
    strpos($normalized, "available services") !== false ||
    strpos($normalized, "available service") !== false ||
    strpos($normalized, "admin services") !== false ||
    strpos($normalized, "what services available") !== false ||
    strpos($normalized, "student services") !== false
) {
    $res = $conn->query("SELECT service_name FROM admin_services ORDER BY id ASC");
    $services = [];

    if ($res) {
        while ($row = $res->fetch_assoc()) {
            $services[] = $row["service_name"];
        }
    }

    if (!empty($services)) {
        sendReply("Available services: " . implode(", ", $services));
    }
}

/* =========================
   11) Admin services direct-name lookup
   ========================= */
$res = $conn->query("SELECT service_name, issued_by, purpose, requirements, fees, notes FROM admin_services");

if ($res) {
    while ($row = $res->fetch_assoc()) {
        $service = mb_strtolower($row["service_name"], 'UTF-8');

        if (strpos($normalized, $service) !== false) {
            $reply = "Service: " . $row["service_name"] . "\n";

            if (!empty($row["issued_by"])) {
                $reply .= "Issued By: " . $row["issued_by"] . "\n";
            }
            if (!empty($row["purpose"])) {
                $reply .= "Purpose: " . $row["purpose"] . "\n";
            }
            if (!empty($row["requirements"])) {
                $reply .= "Requirements: " . $row["requirements"] . "\n";
            }
            if (!is_null($row["fees"])) {
                $reply .= "Fees: Rs." . number_format((float)$row["fees"], 2) . "\n";
            }
            if (!empty($row["notes"])) {
                $reply .= "Notes: " . $row["notes"];
            }

            sendReply(trim($reply));
        }
    }
}

/* =========================
   12) Policies fallback
   ========================= */
$stmt = $conn->prepare("
    SELECT policy_title, policy_description, value_text, fine_applicable, installment_allowed
    FROM policies
    WHERE language = ?
");
$stmt->bind_param("s", $language);
$stmt->execute();
$res = $stmt->get_result();

while ($row = $res->fetch_assoc()) {
    $title = mb_strtolower($row["policy_title"], 'UTF-8');

    if (strpos($normalized, $title) !== false) {
        $reply = $row["policy_title"] . "\n" . $row["policy_description"];

        if (!empty($row["value_text"])) {
            $reply .= "\nInfo: " . $row["value_text"];
        }

        if (!is_null($row["fine_applicable"])) {
            $reply .= "\nFine Applicable: " . ($row["fine_applicable"] ? "Yes" : "No");
        }

        if (!is_null($row["installment_allowed"])) {
            $reply .= "\nInstallment Allowed: " . ($row["installment_allowed"] ? "Yes" : "No");
        }

        sendReply($reply);
    }
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
