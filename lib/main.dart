import 'package:DentaCarts/constants/app_exports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),

        // implement home screen
        /*
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if(state is AuthLoginSuccessState){
              return const LayoutScreen();
            }else{
              return const LoginScreen();
            }
          },
        ),
         */
        home: const LayoutScreen(),
      ),
    );
  }
}
