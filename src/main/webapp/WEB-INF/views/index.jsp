<%--
  Created by IntelliJ IDEA.
  User: iwntutovibrate // PJH
  Date: 2019-03-11
  Time: 오전 11:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <title>WebSocket</title>

    <!-- jQuery -->
    <script src="//code.jquery.com/jquery-3.2.1.min.js"></script>

</head>
<script type="text/javascript">

    var webSocket;

    function connect() {
        webSocket = new WebSocket("ws://localhost:8083/socketHandler");
        webSocket.onopen = onOpen;
        webSocket.onmessage = onMessage;
        webSocket.onclose = onClose;
    }

    function disconnect() {
        webSocket.close();
    }

    function onOpen(openEvent) {
        appendMessage("Socket Server Connected");
    }

    function onMessage(event) {
        appendMessage(event.data);
    }

    function onClose(closeEvent) {
        appendMessage("Disconnect Server");
    }

    function send() {
        var chatElement = $("#chat");
        var nickNameElement = chatElement.find("#nickname");
        var messageElement = chatElement.find("#message");
        webSocket.send(nickNameElement.val()+" : " + messageElement.val());
        messageElement.val("");
    }

    function appendMessage(msg) {

        var chatElement = $("#chat");
        var chatMessageAreaElement = chatElement.find("#chatMessageArea");

        chatMessageAreaElement.append(msg+"<br>");

        var chatArea = chatElement.find("#chatArea");
        var chatAreaHeight = chatArea.height();
        var maxScroll = $("#chatMessageArea").height() - chatAreaHeight;

        chatArea.scrollTop(maxScroll);
    }

    $(document).ready(function() {

        var chatElement = $("#chat");
        var messageElement = chatElement.find("#message");

        messageElement.keydown(function (event) {

            if(event.keyCode === 13){
                send();
            }
            event.stopPropagation();
        });
    });
</script>
<style>
    #chatArea {
        width: 200px; height: 100px; overflow-y: auto; border: 1px solid black;
    }
</style>
</head>
<body>
    <div id="chat">
        이름:<input type="text" id="nickname">
        <input type="button" id="enterBtn" onclick="connect();" value="입장">
        <input type="button" id="exitBtn" onclick="disconnect();" value="나가기">

        <h1>대화 영역</h1>
        <div id="chatArea"><div id="chatMessageArea"></div></div>
        <br/>

        <input type="text" id="message">
        <input type="button" id="sendBtn" onclick="send()" value="전송">
    </div>
</body>
</html>
