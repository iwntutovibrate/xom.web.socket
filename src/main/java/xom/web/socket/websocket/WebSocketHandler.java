package xom.web.socket.websocket;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class WebSocketHandler extends TextWebSocketHandler {

    private static Map<String, WebSocketSession> users = new ConcurrentHashMap<String, WebSocketSession>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {

        log.info("Connect Session ID : " + session.getId());
        users.put(session.getId(), session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {

        log.info("Disconnect Session ID : " + session.getId());
        users.remove(session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message)
            throws Exception {

        for (WebSocketSession userSession : users.values()) {
            userSession.sendMessage(message);
            log.info("message.getPayload({})", message.getPayload());
        }
    }

    @Override
    public void handleTransportError( WebSocketSession session, Throwable exception) throws Exception {
        log.error("Session ID : {} Exception : {}", session.getId(), exception.getMessage());
    }
}