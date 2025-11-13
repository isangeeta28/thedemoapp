
import 'package:demoapp/screens/experience_selection_screen.dart';
import 'package:demoapp/service/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/experience/experience_bloc.dart';
import 'blocs/questionnear/questionnear_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExperienceBloc(
            apiService: ApiService(),
          )..add(LoadExperiences()),
        ),
        BlocProvider(
          create: (context) => QuestionnaireBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Hotspot Host Onboarding',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          fontFamily: 'Inter',
        ),
        home: const ExperienceSelectionScreen(),
      ),
    );
  }
}