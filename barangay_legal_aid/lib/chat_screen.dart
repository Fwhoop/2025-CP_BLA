import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/chat_model.dart';
import 'package:barangay_legal_aid/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final ChatProvider chatProvider;

  const ChatScreen({required this.chatProvider});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.chatProvider.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.chatProvider.removeListener(_refresh);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    widget.chatProvider.addMessage(message, true);
    
    Future.delayed(Duration(seconds: 1), () {
      widget.chatProvider.addMessage(
        "I received your message: '$message'. How can I assist you further?",
        false,
      );
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentSession = widget.chatProvider.currentSession;
    
    return Container(
      color: Color(0xFFFFFFFF),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF99272D),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Replaced icon with text label
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'BOT',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  currentSession?.title ?? 'New Chat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: currentSession == null || currentSession.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Replaced icon with text
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF36454F).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '💬',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Start a new conversation',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF36454F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Type a message to begin chatting',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF36454F).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: currentSession.messages.length,
                    itemBuilder: (context, index) {
                      final message = currentSession.messages[index];
                      return ChatBubble(message: message);
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(top: BorderSide(color: Color(0xFF36454F).withOpacity(0.2))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Color(0xFF36454F).withOpacity(0.3)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF99272D),
                    shape: BoxShape.circle,
                  ),
                  child: TextButton(
                    onPressed: _sendMessage,
                    child: Text(
                      'SEND',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF99272D),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  'BOT',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                radius: 16,
              ),
            ),
            SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Color(0xFF99272D)
                        : Color(0xFF36454F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF36454F).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF99272D),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  'YOU',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                radius: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}