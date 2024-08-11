import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/pages/conversation_page.dart';
import 'package:flutter_chatgpt_clone/features/global/const/page_const.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.conversationPage:
        // final argument = settings.arguments! as ChatConversationEntity?;
        {
          return materialBuilder(
            widget: ConversationPage(
              chatConversationEntity: args as ChatConversationEntity?,
            ),
            settings: settings,
          );
        }
      default:
        return materialBuilder(
          settings: settings,
          widget: ErrorPage(),
        );
    }
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("error"),
      ),
      body: Center(
        child: Text("error"),
      ),
    );
  }
}

MaterialPageRoute materialBuilder(
    {required Widget widget, required RouteSettings settings}) {
  return MaterialPageRoute(settings: settings, builder: (_) => widget);
}
