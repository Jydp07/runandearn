import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tab_change_state.dart';

class TabChangeCubit extends Cubit<TabChangeState> {
  TabChangeCubit() : super(TabChangeState(selectedIndex: 0));

  onTabChange(value){
    emit(TabChangeState(selectedIndex: value));
  }
}
