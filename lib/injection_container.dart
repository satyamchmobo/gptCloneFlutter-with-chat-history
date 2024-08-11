import 'package:flutter_chatgpt_clone/features/chat/chat_injection_container.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/local_data_source/chat_history_hive_service.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/data/local_data_source/chat_history_hive_service_impl.dart';
import 'package:flutter_chatgpt_clone/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  final http.Client httpClient = http.Client();

  sl.registerSingleton<ChatHistoryHiveService>(ChatHistoryHiveServiceImpl());
  sl.registerLazySingleton<http.Client>(() => httpClient);
  sl.registerFactory(() => ChatHistoryBloc(sl.get<ChatHistoryHiveService>()));
  sl.registerSingleton(ChatHistoryHiveServiceImpl());

  await chatInjectionContainer();
}
