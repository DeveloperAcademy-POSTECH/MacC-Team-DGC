const functions = require("firebase-functions");
const admin = require("firebase-admin");

const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

admin.initializeApp();
const firestore = admin.firestore();
const messaging = admin.messaging();

exports.push_send = onRequest(async (req, res) => {
    try {
      // 대상 디바이스의 토큰 배열
      const tokens = req.body.data.tokens; // 이제 tokens 배열로부터 토큰을 가져옵니다.
      console.log("Token --> ", tokens)
  
      if (!Array.isArray(tokens)) {
        return res.status(400).json({ error: "Invalid 'tokens' parameter. It should be an array." });
      }
  
      // 푸시 메시지 설정
      const messages = tokens.map((token) => ({
        notification: {
          title: "테스트 데이터 발송",
          body: "데이터가 잘 가나요?",
        },
        token: token,
      }));
  
      // 여러 푸시 메시지 전송
      const responses = await Promise.all(messages.map((message) => messaging.send(message)));
      console.log("Successfully sent messages:", responses);
  
      res.status(200).json({ success: true, data: responses });
  
    } catch (error) {
      console.error("Error Sending message:", error);
      res.status(500).json({ error: "Failed to send message" });
    }
  });