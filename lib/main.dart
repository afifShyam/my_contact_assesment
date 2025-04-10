import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:my_contact/bloc/index.dart';
import 'package:my_contact/screen/my_contact.dart';
import 'package:my_contact/repositories/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDirectory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      appDirectory.path,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
          title: 'Assesment flutter',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 58, 85, 173),
            ),
            useMaterial3: true,
          ),
          home: RepositoryProvider(
            create: (context) => ContactRepository(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      ContactBloc(contactRepository: context.read<ContactRepository>())
                        ..add(LoadContacts(page: 1)),
                ),
                BlocProvider<HelperCubit>(
                  create: (context) => HelperCubit(),
                ),
              ],
              child: MyContact(),
            ),
          )),
    );
  }
}
