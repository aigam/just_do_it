part of 'chat_bloc.dart';

class ChatEvent {}

class UpdateMenuEvent extends ChatEvent {}

class CloseSlidingPanelEvent extends ChatEvent {}

class StartSocket extends ChatEvent {
  BuildContext context;
  String? access;
  VoidCallback updateData;
  StartSocket(this.context, this.access,this.updateData);
}

class SendMessageEvent extends ChatEvent {
  String message;
  String id;
  String myId;
  int? categoryId;
  SendMessageEvent(this.message, this.id, this.myId,{this.categoryId});
}

class GetListMessage extends ChatEvent {}
class CloseSocketEvent extends ChatEvent {}


class GetListMessageItem extends ChatEvent {
  String access;
  GetListMessageItem(this.access);
}

class ChatStarted extends ChatEvent {
  final int senderId;
  final int receiverId;
  final String token;

  ChatStarted({
    required this.senderId,
    required this.receiverId,
    required this.token,
  });
}

class UpdateChat extends ChatEvent {
  final List<ChatMessage> messages;

  UpdateChat({required this.messages});
}

class GetChatSupport extends ChatEvent {}

class CheckNewMessageSupport extends ChatEvent {}

class RefreshTripEvent extends ChatEvent {}

class ReconnectEvent extends ChatEvent {}

class RefreshPersonChatEvent extends ChatEvent {}
