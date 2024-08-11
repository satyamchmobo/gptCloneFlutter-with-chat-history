import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/core/http_certificate_manager.dart';
import 'package:flutter_chatgpt_clone/features/app/route/on_generate_route.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';
import 'package:flutter_chatgpt_clone/features/chat/presentation/pages/conversation_page.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/local_data_source/chat_history_hive_service.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_event.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/pages/chat_history_page.dart';
import 'package:flutter_chatgpt_clone/features/global/const/page_const.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/theme_cubit.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';
import 'injection_container.dart' as di;
import 'features/global/theme/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await di.init();
  await sl.get<ChatHistoryHiveService>().initHiveLocalStorage();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<ChatHistoryBloc>()..add(LoadChatHistory()),
        ),
        // BlocProvider(
        //   lazy: true,
        //   create: (_) => di.sl<ChatConversationCubit>(),
        // ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          print(themeMode.toString());
          return MaterialApp(
            title: 'Chatgpt',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: OnGenerateRoute.route,
            routes: {
              "/": (context) {
                return ChatHistoryScreen();
              },

              // ... other routes
            },
          );
        },
      ),
    );
  }
}
