// Store selected language (default English)
let selectedLanguage = "English";

// Send Message Function
function sendMessage() {
  const input = document.getElementById("userInput");
  const message = input.value.trim();

  if (message === "") return;

  const chatBody = document.getElementById("chatBody");

  // User Message
  const userMsg = document.createElement("div");
  userMsg.className = "user-message";
  userMsg.textContent = message;
  chatBody.appendChild(userMsg);

  input.value = "";

  // Bot Reply (based on language)
  const botMsg = document.createElement("div");
  botMsg.className = "bot-message";

if (selectedLanguage === "Tamil") {
    botMsg.textContent = "வணக்கம்! நான் ASKNOVA, SDNB வைஷ்ணவா மகளிர் கல்லூரியின் சேவை உதவியாளர். இன்று நான் உங்களுக்கு எவ்வாறு உதவலாம்?";
  } else {
    botMsg.textContent = "Hello! I’m ASKNOVA, the Service Assistant Bot of SDNB Vaishnav College for Women. How can I help you today?";
  }

  setTimeout(() => {
    chatBody.appendChild(botMsg);
    chatBody.scrollTop = chatBody.scrollHeight;
  }, 500);
}

// Language Selection Function
function selectLanguage(lang) {
  selectedLanguage = lang;

  const botMessage = document.getElementById("botMessage");

  if (lang === "Tamil") {
    botMessage.innerHTML =
      "👋 SDNB ASKNOVA-விற்கு வரவேற்கிறோம். உங்கள் கேள்விகளுக்கு உதவ நான் இங்கு இருக்கும் உங்கள் சேவை உதவியாளர் 😊.";
  } else {
    botMessage.innerHTML =
      "👋 Welcome to SDNB ASKNOVA. I am your service assistant, here to assist you with your inquiries 😊.";
  }
}


