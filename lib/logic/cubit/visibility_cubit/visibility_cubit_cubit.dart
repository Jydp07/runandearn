import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'visibility_cubit_state.dart';

class VisibilityCubit extends Cubit<VisibilityCubitState> {
  VisibilityCubit() : super(VisibilityCubitState(isVisible: true));

  void changeVisibility(){
    emit(VisibilityCubitState(isVisible: !state.isVisible));
  }
}
