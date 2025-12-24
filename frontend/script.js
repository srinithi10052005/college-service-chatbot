document.getElementById("sendBtn").addEventListener("click", sendMessage);

function sendMessage() {
    let input = document.getElementById("userInput").value;

    if (input === "") return;

    let chatbox = document.getElementById("chatbox");

    
    chatbox.innerHTML += `<p><b>You:</b> ${input}</p>`;

    let reply = "This message will come from backend later.";

    chatbox.innerHTML += `<p><b>Bot:</b> ${reply}</p>`;

    document.getElementById("userInput").value = "";

    chatbox.scrollTop = chatbox.scrollHeight;
}

