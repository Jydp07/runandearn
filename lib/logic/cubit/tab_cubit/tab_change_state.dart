part of 'tab_change_cubit.dart';

// ignore: must_be_immutable
class TabChangeState extends Equatable {
  TabChangeState({required this.selectedIndex});
  int selectedIndex;
  @override
  List<Object> get props => [selectedIndex];
}

