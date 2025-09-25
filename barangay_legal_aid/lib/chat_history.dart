import 'package:flutter/material.dart';
import 'package:barangay_legal_aid/chat_model.dart';
import 'package:barangay_legal_aid/chat_provider.dart';

class ChatHistorySidebar extends StatelessWidget {
  final ChatProvider chatProvider;

  const ChatHistorySidebar({required this.chatProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF36454F),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF36454F),
              border: Border(bottom: BorderSide(color: Color(0xFF99272D).withOpacity(0.5))),
            ),
            child: Row(
              children: [
                Icon(Icons.chat, color: Color(0xFFFFFFFF)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Chat History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Color(0xFFFFFFFF)),
                  onPressed: chatProvider.createNewSession,
                  tooltip: 'New Chat',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.chatSessions.length,
              itemBuilder: (context, index) {
                final session = chatProvider.chatSessions[index];
                final isSelected = chatProvider.currentSession?.id == session.id;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF99272D).withOpacity(0.8) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ChatSessionTile(
                    session: session,
                    isSelected: isSelected,
                    onTap: () => chatProvider.selectSession(session.id),
                    onDelete: () => chatProvider.deleteSession(session.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatSessionTile extends StatelessWidget {
  final ChatSession session;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ChatSessionTile({
    required this.session,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.chat_bubble_outline,
        color: isSelected ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF).withOpacity(0.7),
      ),
      title: Text(
        session.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF).withOpacity(0.8),
        ),
      ),
      subtitle: Text(
        '${session.messages.length} messages',
        style: TextStyle(fontSize: 12, color: Color(0xFFFFFFFF).withOpacity(0.6)),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, size: 18, color: Color(0xFFFFFFFF).withOpacity(0.7)),
        onPressed: onDelete,
      ),
      onTap: onTap,
      selected: isSelected,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}
