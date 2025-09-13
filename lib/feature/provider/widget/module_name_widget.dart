import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/repository/module_repository.dart';
import '../../module/model/module_model.dart'; // ensure correct import

class ModuleNameWidget extends StatelessWidget {
  final String moduleId;
  const ModuleNameWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModuleBloc(repository: ModuleRepository())..add(GetModules()),
      child: BlocBuilder<ModuleBloc, ModuleState>(
        builder: (context, state) {
          if (state is ModuleLoading) {
            return const CupertinoActivityIndicator();
          } else if (state is ModuleLoaded) {
            // final ModuleModel module = state.modules.firstWhere((module) => module.id == moduleId,);
            final ModuleModel? module = state.modules.firstWhere(
          (module) => module.id == moduleId,
              orElse: () => ModuleModel(id: '', name: 'Module Name', image: ''),
            );
            if(module == null){
              return Text('Module Name', style: textStyle12(context, color: CustomColor.descriptionColor),);
            }
            return Text(
              module.name.toString(),
              style: textStyle12(context, color: CustomColor.descriptionColor),
            );

          } else if (state is ModuleError) {
            return Text('Error: ${state.message}');
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
