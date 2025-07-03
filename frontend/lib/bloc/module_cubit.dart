import 'package:flutter_bloc/flutter_bloc.dart';

enum ModuleType {
  home,
  hrm,
  project,
  purchasing,
  sales,
  inventory,
  accounting,
  reports,
  settings,
}

class ModuleCubit extends Cubit<ModuleType> {
  ModuleCubit() : super(ModuleType.home);

  void select(ModuleType module) => emit(module);
}
