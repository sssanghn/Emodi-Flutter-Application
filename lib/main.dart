import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:emodi/Auth/explanation.dart';
import 'package:emodi/Auth/auth_manager.dart';
import 'package:emodi/Auth/auth_repository.dart';
import 'package:emodi/Auth/auth_remote_api.dart';
import 'package:emodi/DataSource/local_data_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null); // 한국어 로케일 초기화
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final AuthRepository? authRepository;
  final AuthManager? authManager;

  const MyApp({Key? key, this.authManager, this.authRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthRepository _authRepository;
  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AuthRepository(LocalDataStorage(), AuthRemoteApi());
    _authManager = widget.authManager ?? AuthManager(_authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', ''), // 한국어
        const Locale('en', ''), // 영어
      ],
      home: ExplanationPage(authRepository: _authRepository, authManager: _authManager),
    );
  }
}
