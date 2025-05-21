import 'package:bizbooster2x/feature/module/screen/module_category_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class InitialHomeScreen extends StatefulWidget {
  const InitialHomeScreen({super.key});

  @override
  State<InitialHomeScreen> createState() => _InitialHomeScreenState();
}

class _InitialHomeScreenState extends State<InitialHomeScreen> {

  String selectedModuleName = '';
  String selectedModuleId = '';
  bool isHomeScreen = true;
  void toggleScreen(bool value, String moduleName, String moduleId) {
    setState(() {
      isHomeScreen = value;
      selectedModuleName = moduleName;
      selectedModuleId = moduleId;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isHomeScreen ?
    HomeScreen(onToggle: toggleScreen,moduleName: selectedModuleName, moduleId: selectedModuleId,):
    ModuleCategoryScreen(
        onToggle: (val) => toggleScreen(val, selectedModuleName, selectedModuleId),
        moduleName: selectedModuleName,
        moduleId: selectedModuleId,
    );
  }
}