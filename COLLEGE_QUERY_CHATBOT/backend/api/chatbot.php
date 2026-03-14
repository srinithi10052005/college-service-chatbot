<?php
include("../config/db.php");
header("Content-Type: application/json");

// Read JSON body
$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

$message = strtolower(trim($data["message"] ?? ""));
$language = $data["language"] ?? "English";

if ($message === "") {
    if ($language === "Tamil") {
        echo json_encode(["reply" => "தயவு செய்து உங்கள் கேள்வியை உள்ளிடவும்."]);
    } else {
        echo json_encode(["reply" => "Please type your question."]);
    }
    exit;
}

/* =========================
   1) Greeting
   ========================= */
$greetings = [
    "hi", "hello", "hey", "good morning", "good afternoon", "good evening",
    "வணக்கம்", "ஹாய்", "ஹலோ", "காலை வணக்கம்", "மாலை வணக்கம்"
];

if (in_array($message, $greetings)) {
    if ($language === "Tamil") {
        echo json_encode([
            "reply" => "👋 எஸ்டிஎன்பி ASKNOVA-க்கு வரவேற்கிறோம். நான் உங்கள் சேவை உதவியாளர். உங்கள் கேள்விகளுக்கு உதவ தயாராக உள்ளேன்."
        ]);
    } else {
        echo json_encode([
            "reply" => "👋 Welcome to SDNB ASKNOVA. I am your service assistant. How can I help you today?"
        ]);
    }
    exit;
}

/* =========================
   2) Attendance Percentage Rule
   ========================= */
if (preg_match('/(\d+)\s*%/', $message, $m)) {
    $percent = floatval($m[1]);

    $stmt = $conn->prepare("
        SELECT category_code, eligibility, condonation_fee, condonation_required
        FROM attendance_eligibility_rules
        WHERE ? BETWEEN attendance_min AND attendance_max
        LIMIT 1
    ");

    if ($stmt) {
        $stmt->bind_param("d", $percent);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            if ($language === "Tamil") {
                $reply = "வகை " . $row["category_code"] . ": " . $row["eligibility"];
                if ((int)$row["condonation_required"] === 1) {
                    $reply .= " Condonation Fee: Rs." . $row["condonation_fee"];
                }
            } else {
                $reply = "Category " . $row["category_code"] . ": " . $row["eligibility"];
                if ((int)$row["condonation_required"] === 1) {
                    $reply .= " Condonation Fee: Rs." . $row["condonation_fee"];
                }
            }

            echo json_encode(["reply" => $reply]);
            exit;
        }
    }
}

/* =========================
   3) Keyword Matching by Language
   ========================= */
$stmt = $conn->prepare("
    SELECT keywords, response
    FROM chatbot_intents
    WHERE language = ?
");

if (!$stmt) {
    echo json_encode(["reply" => "Database error: " . $conn->error]);
    exit;
}

$stmt->bind_param("s", $language);
$stmt->execute();
$result = $stmt->get_result();

if ($language === "Tamil") {
    $reply = "மன்னிக்கவும், உங்கள் கேள்வியை நான் புரிந்து கொள்ளவில்லை.";
} else {
    $reply = "Sorry, I don't understand your question.";
}

$bestReply = $reply;
$bestMatchCount = 0;

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $keywords = strtolower(trim($row["keywords"]));
        $response = $row["response"];

        // Full keyword string match gets highest priority
        if ($keywords !== "" && strpos($message, $keywords) !== false) {
            $bestReply = $response;
            $bestMatchCount = 999;
            break;
        }

        // Count matched words
        $words = preg_split('/\s+/', $keywords);
        $matchCount = 0;

        foreach ($words as $w) {
            $w = trim($w);
            if ($w !== "" && strpos($message, $w) !== false) {
                $matchCount++;
            }
        }

        // Save best matching response
        if ($matchCount > $bestMatchCount) {
            $bestMatchCount = $matchCount;
            $bestReply = $response;
        }
    }
}

// Require at least 1 keyword match
if ($bestMatchCount > 0) {
    $reply = $bestReply;
}

echo json_encode(["reply" => $reply]);
?>
