part of 'visibility_cubit_cubit.dart';

// ignore: must_be_immutable
class VisibilityCubitState extends Equatable{
  VisibilityCubitState({required this.isVisible});
  bool isVisible = true;
  
  @override
  List<Object?> get props => [isVisible];
}

