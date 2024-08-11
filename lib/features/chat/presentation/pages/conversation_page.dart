import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_converstaion_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/chat_message_single_item.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/custom_theme_switch.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/widgets/example_widget.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_event.dart';
import 'package:flutter_chatgpt_clone/features/global/const/app_const.dart';
import 'package:flutter_chatgpt_clone/features/global/custom_text_field/custom_text_field.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class ConversationPage extends StatefulWidget {
  ConversationPage({Key? key, this.chatConversationEntity}) : super(key: key);
  ChatConversationEntity? chatConversationEntity;
  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController _messageController = TextEditingController();
  bool _isRequestProcessing = false;

  ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var conversationCubit = sl<ChatConversationCubit>();
  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_scrollController.hasClients) {
      Timer(
        Duration(milliseconds: 100),
        () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.decelerate),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: Text('Clear Conversation'),
              leading: Icon(Icons.delete_outline_outlined),
              onTap: () {
                // Implement clear conversation logic
              },
            ),
            ListTile(
              title: Text('Dark Mode'),
              leading: Icon(Icons.nightlight_outlined),
              onTap: () {
                // Implement dark mode toggle logic
              },
            ),
            ListTile(
              title: Text('Update & FAQ'),
              leading: Icon(Icons.ios_share_sharp),
              onTap: () {
                // Implement update & FAQ logic
              },
            ),
            ListTile(
              title: Text('Log out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                // Implement logout logic
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 55,
                        ),
                        // Align(
                        //     alignment: Alignment.topRight,
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(right: 20),
                        //       child: CustomAdvanceSwitch(),
                        //     )),

                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: IconButton(
                                  icon: Icon(Feather.edit),
                                  onPressed: () async {
                                    await showEditDialog(context,
                                        widget.chatConversationEntity!);
                                  }),
                            )),
                        Expanded(
                          child: BlocBuilder<ChatConversationCubit,
                                  ChatConversationState>(
                              bloc: conversationCubit,
                              buildWhen: (p, c) => p != c,
                              builder: (context, chatConversationState) {
                                conversationCubit
                                    .init(widget.chatConversationEntity!);
                                if (chatConversationState
                                    is ChatConversationLoaded) {
                                  print('HEREEVERYTIME');
                                  final chatMessages =
                                      chatConversationState.chatMessages;

                                  if (chatMessages.isEmpty) {
                                    return ExampleWidget(
                                      onMessageController: (message) {
                                        setState(() {
                                          _messageController.value =
                                              TextEditingValue(text: message);
                                        });
                                      },
                                    );
                                  } else {
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: _calculateListItemLength(
                                            chatMessages.length),
                                        controller: _scrollController,
                                        itemBuilder: (context, index) {
                                          if (index >= chatMessages.length) {
                                            return _responsePreparingWidget();
                                          } else {
                                            return ChatMessageSingleItem(
                                              chatMessage: chatMessages[index],
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  }
                                }
                                return ExampleWidget(
                                  onMessageController: (message) {
                                    setState(() {
                                      _messageController.value =
                                          TextEditingValue(text: message);
                                    });
                                  },
                                );
                              }),
                        ),
                        CustomTextField(
                          isRequestProcessing: _isRequestProcessing,
                          textEditingController: _messageController,
                          onTap: () async {
                            _promptTrigger();
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 90),
                          child: Text(
                            "Made by Anitan, used OpenAI",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 10),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigation..pop(context);
                },
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: Text(
                'ChatName1',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 50, left: 10),
          //     child: IconButton(
          //       icon: Icon(
          //         Icons.menu,
          //         size: 30,
          //       ),
          //       onPressed: () {
          //         _scaffoldKey.currentState?.openDrawer();
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  int _calculateListItemLength(int length) {
    if (_isRequestProcessing == false) {
      return length;
    } else {
      return length + 1;
    }
  }

  Widget _responsePreparingWidget() {
    return Container(
      height: 60,
      child: Image.asset("assets/loading_response.gif"),
    );
  }

  void _promptTrigger() {
    if (_messageController.text.isEmpty) {
      return;
    }

    final humanChatMessage = ChatMessageEntity(
      messageId: ChatGptConst.Human,
      queryPrompt: _messageController.text,
    );
    print('here1');
    conversationCubit
        .chatConversation(
            chatMessage: humanChatMessage,
            onCompleteReqProcessing: (isRequestProcessing) {
              setState(() {
                _isRequestProcessing = isRequestProcessing;
              });
            })
        .then((value) {
      setState(() {
        _messageController.clear();
      });
      if (_scrollController.hasClients) {
        Timer(
          Duration(milliseconds: 100),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate),
        );
      }
    });
  }
}

final _formKey = GlobalKey<FormState>();
final _newNameController = TextEditingController();

Future<void> showEditDialog(
    BuildContext context, ChatConversationEntity chat) async {
  _newNameController.text =
      chat.chatConversationName ?? ''; // Set initial value

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Chat Name'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _newNameController,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a name for the chat.';
                }
                return null; // No error
              },
              decoration: InputDecoration(
                hintText: 'Enter new name',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Update chat name using Bloc (example)
                  print('new name: ${_newNameController.text}');
                  BlocProvider.of<ChatHistoryBloc>(context)
                      .add(EditChatEvent(chat.id!, _newNameController.text));
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      });
}
