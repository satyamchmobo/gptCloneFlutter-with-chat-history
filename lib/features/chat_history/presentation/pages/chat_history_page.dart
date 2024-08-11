import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/custom_theme_switch.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_event.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_state.dart';
import 'package:flutter_chatgpt_clone/features/global/const/page_const.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/theme_cubit.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:uuid/uuid.dart';

class ChatHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Chat History'),
        actions: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: CustomAdvanceSwitch(),
              )),
        ],
      ),
      body: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
        builder: (context, state) {
          if (state is ChatHistoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatHistoryLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
              child: ListView.separated(
                itemCount: state.chats.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return Container(
                    // Wrap ListTile with Container
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      // Set border radius
                    ),
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await showDeleteDialog(context, chat);
                            },
                          ),
                          // IconButton(
                          //   icon: Icon(Feather.edit),
                          //   onPressed: () async {
                          //     await showEditDialog(context, chat);
                          //     // Navigate to edit chat screen
                          //   },
                          // ),
                        ],
                      ),
                      title: Text(
                        chat.chatConversationName ?? 'Untitled Chat',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Last message: ...',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ), // Implement timestamp logic
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.conversationPage,
                            arguments: chat);
                        // Navigate to chat details screen
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is ChatHistoryError) {
            return Center(child: Text(state.message));
          } else if (state is ChatHistoryDeleting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Or show a confirmation message
          } else if (state is ChatHistoryEmpty) {
            return Center(child: Text('No chat history found'));
          } else {
            return Center(
                child: Text('No chat history found')); // Handle other states
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('creating chat1');
          var emptyChat = ChatConversationEntity(
              id: generateUUID(),
              chatConversationName: "Untitled Chat",
              choices: []);
          BlocProvider.of<ChatHistoryBloc>(context)
              .add(CreateChatEvent(emptyChat));
          print('creating chat2');

          Navigator.pushNamed(context, PageConst.conversationPage,
              arguments: emptyChat);
          // Navigate to create new chat screen
        },
        child: Icon(
          Icons.chat_outlined,
          color: BlocProvider.of<ThemeCubit>(context).state == ThemeMode.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}

String generateUUID() {
  final uuid = Uuid();
  return uuid.v4();
}

//create custom dialog for delete and edit chat history
Future<void> showDeleteDialog(
    BuildContext context, ChatConversationEntity chat) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Chat'),
          content: Text('Are you sure you want to delete this chat?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  BlocProvider.of<ChatHistoryBloc>(context)
                      .add(DeleteChatEvent(chat.id!));
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        );
      });
}
