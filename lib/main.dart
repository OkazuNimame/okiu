import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:okiu/SubjectManagementPage/AddSubjectPageParts/AddSubjectPage.dart';
import 'package:okiu/UIParts/MainPats/SubjectManagement_Page_UI.dart';
import 'package:okiu/notification/DeadlineNotification.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();

  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyOkiu',
      theme: ThemeData(
        fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          scrollDirection: Axis.vertical,
          children: [SubjectmanagementPageUi(), Addsubjectpage()],
        ),
      ),
    );
  }
}
