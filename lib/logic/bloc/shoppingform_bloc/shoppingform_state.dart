part of 'shoppingform_bloc.dart';

class ShoppingformState extends Equatable {
  const ShoppingformState({
    required this.isPriceValid,
      required this.isNamevalid,
      required this.isPhotoValid,
      required this.isMultiplePhotoValid,
      required this.isDescriptionValid,
      required this.isDataValid,
      required this.image,
      required this.price,
      required this.isLoading,
      required this.error,
      required this.pname,
      required this.multipleImage,
      required this.isSubmitSuccess,
      required this.description,
      this.moreDescription,
  });
  final bool isPriceValid;
  final bool isNamevalid;
  final bool isPhotoValid;
  final bool isDataValid;
  final bool isMultiplePhotoValid;
  final bool isDescriptionValid;
  final bool isSubmitSuccess;
  final bool isLoading;
  final String error;
  final String pname;
  final double price;
  final File image;
  final List<File> multipleImage;
  final String description;
  final String? moreDescription;

  ShoppingformState copyWith({ bool? isPriceValid,
    bool? isNamevalid,
    bool? isPhotoValid,
    bool? isDataValid,
    bool? isMultiplePhotoValid,
    bool? isDescriptionValid,
    String? pname,
    double? price,
    bool? isLoading,
    String? error,
    bool? isSubmitSuccess,
    File? image,
    String? description,
    List<File>? multipleImage,
    String? moreDescription,}){
    return ShoppingformState( isPriceValid: isPriceValid ?? this.isPriceValid,
        isNamevalid: isNamevalid ?? this.isNamevalid,
        isPhotoValid: isPhotoValid ?? this.isPhotoValid,
        isMultiplePhotoValid: isMultiplePhotoValid ?? this.isMultiplePhotoValid,
        isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
        pname: pname ?? this.pname,
        price: price ?? this.price,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        isDataValid: isDataValid ?? this.isDataValid,
        image: image ?? this.image,
        isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
        description: description ?? this.description,
        multipleImage: multipleImage ?? this.multipleImage,
        moreDescription: moreDescription ?? this.moreDescription);
  }
  @override
  List<Object?> get props => [isDescriptionValid,
        isMultiplePhotoValid,
        isSubmitSuccess,
        isPhotoValid,
        isNamevalid,
        isPriceValid,
        pname,
        price,
        isLoading,
        error,
        image,
        description,
        isDataValid,
        multipleImage,
        moreDescription];
}
