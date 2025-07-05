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
  crm, 
}

class ModuleState {
  final ModuleType module;
  final String? submodule; 
  const ModuleState(this.module, {this.submodule});

  ModuleState copyWith({ModuleType? module, String? submodule}) {
    return ModuleState(
      module ?? this.module,
      submodule: submodule ?? this.submodule,
    );
  }
}

class ModuleCubit extends Cubit<ModuleState> {
  ModuleCubit() : super(const ModuleState(ModuleType.home));

  void select(ModuleType module, {String? submodule}) {
    emit(ModuleState(module, submodule: submodule));
  }
}
