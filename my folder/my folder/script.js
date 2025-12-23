document.getElementById("sendBtn").addEventListener("click", sendMessage);

function sendMessage() {
    let input = document.getElementById("userInput").value;

    if (input === "") return;

    let chatbox = document.getElementById("chatbox");

    // Show user message
    chatbox.innerHTML += `<p><b>You:</b> ${input}</p>`;

    // Dummy bot reply (frontend only)
    let reply = "This message will come from backend later.";

    chatbox.innerHTML += `<p><b>Bot:</b> ${reply}</p>`;

    // Clear input
    document.getElementById("userInput").value = "";

    // Scroll to bottom
    chatbox.scrollTop = chatbox.scrollHeight;
}

