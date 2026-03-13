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

/* ==================================
   ✅ 1) GREETING BASED ON LANGUAGE
   ================================== */
if (in_array($message, [
    "hi", "hello", "hey", "good morning", "good afternoon", "good evening",
    "வணக்கம்", "ஹாய்", "ஹலோ", "காலை வணக்கம்", "மாலை வணக்கம்"
])) {
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

/* ================================
   ✅ 2) PERCENTAGE ATTENDANCE RULE
   ================================ */
if (preg_match('/(\d+)\s*%/', $message, $m)) {
    $percent = floatval($m[1]);

    $stmt = $conn->prepare("
        SELECT category_code, eligibility, condonation_fee, condonation_required
        FROM attendance_eligibility_rules
        WHERE ? BETWEEN attendance_min AND attendance_max
        LIMIT 1
    ");
    $stmt->bind_param("d", $percent);
    $stmt->execute();
    $res = $stmt->get_result();

    if ($row = $res->fetch_assoc()) {
        $extra = "";
        if ((int)$row["condonation_required"] === 1) {
            $extra = " Condonation Fee: Rs." . $row["condonation_fee"];
        }

        if ($language === "Tamil") {
            echo json_encode([
                "reply" => "வகை " . $row["category_code"] . ": " . $row["eligibility"] . $extra
            ]);
        } else {
            echo json_encode([
                "reply" => "Category " . $row["category_code"] . ": " . $row["eligibility"] . $extra
            ]);
        }
        exit;
    }
}

/* ==================================
   ✅ 3) NORMAL KEYWORD INTENT MATCHING
   ================================== */
$sql = "SELECT keywords, response FROM chatbot_intents";
$result = $conn->query($sql);

if ($language === "Tamil") {
    $reply = "மன்னிக்கவும், உங்கள் கேள்வியை நான் புரிந்து கொள்ளவில்லை.";
} else {
    $reply = "Sorry, I don't understand your question.";
}

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $keywords = strtolower($row["keywords"]);

        // Match full keyword string
        if (strpos($message, $keywords) !== false) {
            $reply = $row["response"];
            break;
        }

        // Match any word in keywords
        $words = preg_split('/\s+/', $keywords);
        foreach ($words as $w) {
            $w = trim($w);
            if ($w !== "" && strpos($message, $w) !== false) {
                $reply = $row["response"];
                break 2;
            }
        }
    }
}

echo json_encode(["reply" => $reply]);
?>