import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runandearn/models/shopping_model.dart';
import 'package:runandearn/repository/database_repository.dart';

part 'shoppingform_event.dart';
part 'shoppingform_state.dart';

class ShoppingformBloc extends Bloc<ShoppingformEvent, ShoppingformState> {
  ShoppingformBloc()
      : super(ShoppingformState(
          isPriceValid: true,
          isNamevalid: true,
          isPhotoValid: true,
          isLoading: false,
          error: "",
          isDataValid: true,
          isMultiplePhotoValid: true,
          isDescriptionValid: true,
          image: File(""),
          price: 0,
          pname: '',
          moreDescription: "",
          multipleImage: const [],
          description: '',
          isSubmitSuccess: false,
        )) {
    on<OnNameChanged>(_onNameValid);
    on<OnPriceChanged>(_onPriceValid);
    on<OnImageChanged>(_onImageValid);
    on<OnDescriptionChanged>(_onDescriptionValid);
    on<OnMultipleImageChanged>(_onMultipleImageValid);
    on<OnMoreDescriptionChanged>((event, emit) {
      emit(state.copyWith(moreDescription: event.moreDescription));
    });
    on<OnSubmitData>(_onSetShoppingData);
    on<OnUpdateShoppingData>(_onUpdateData);
  }

  bool _isNameValid(String name) {
    return name.isNotEmpty;
  }

  bool _isPriceValid(double price) {
    return price > 0;
  }

  bool _isImageValid(File? image) {
    return image!.path.isNotEmpty;
  }

  bool _isDescriptionValid(String description) {
    return description.length > 100;
  }

  bool _isMultipleImage(List<File> multipleImage) {
    return multipleImage.isNotEmpty;
  }

  _onNameValid(OnNameChanged event, Emitter<ShoppingformState> emit) {
    emit(state.copyWith(
        isDataValid: true,
        pname: event.name,
        isNamevalid: _isNameValid(event.name)));
  }

  _onPriceValid(OnPriceChanged event, Emitter<ShoppingformState> emit) {
    emit(state.copyWith(
        isDataValid: true,
        price: event.price,
        isPriceValid: _isPriceValid(event.price)));
  }

  _onImageValid(OnImageChanged event, Emitter<ShoppingformState> emit) async {
    PermissionStatus permission = await Permission.photos.request();
    if (permission == PermissionStatus.denied) {
      await Permission.photos.request();
      if (permission == PermissionStatus.granted) {
        return;
      }
    }
    final ImagePicker picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final selectedImage = File(file.path);
      emit(state.copyWith(
          isDataValid: true,
          image: selectedImage,
          isPhotoValid: _isImageValid(selectedImage)));
    } else {
      emit(state.copyWith(error: "Please Pick Image"));
    }
  }

  _onDescriptionValid(
      OnDescriptionChanged event, Emitter<ShoppingformState> emit) {
    emit(state.copyWith(
        isDataValid: true,
        description: event.description,
        isDescriptionValid: _isDescriptionValid(event.description)));
  }

  _onMultipleImageValid(
      OnMultipleImageChanged event, Emitter<ShoppingformState> emit) async {
    final ImagePicker picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      List<File> selectedImages = [];
      for (var file in files) {
        selectedImages.add(File(file.path));
      }
      emit(state.copyWith(
          isDataValid: true,
          multipleImage: selectedImages,
          isMultiplePhotoValid: _isMultipleImage(selectedImages)));
    } else {
      state.copyWith(error: "Please Pick Image");
    }
  }

  _onSetShoppingData(
      OnSubmitData event, Emitter<ShoppingformState> emit) async {
    emit(state.copyWith(
        isDataValid: _isNameValid(state.pname) &&
            _isPriceValid(state.price) &&
            _isImageValid(state.image) &&
            _isDescriptionValid(state.description) &&
            _isMultipleImage(state.multipleImage)));
    if (state.isDataValid) {
      emit(state.copyWith(isLoading: true));
      try {
        final db = DatabaseRepositoryImpl();
        final shopping = ShoppingModel();
        final storageRefImage = FirebaseStorage.instance
            .ref()
            .child("shopping_image")
            .child('${state.image.path}.jpg');

        await storageRefImage.putFile(state.image);

        final getImageUrl = await storageRefImage.getDownloadURL();

        List<String> imagesUrl = [];
        for (var image in state.multipleImage) {
          final storageRefImages = FirebaseStorage.instance
              .ref()
              .child("shopping_images")
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          await storageRefImages.putFile(image);
          final getImagesUrl = await storageRefImages.getDownloadURL();
          imagesUrl.add(getImagesUrl);
        }

        await db.saveShoppingData(shopping.copyWith(
            name: state.pname,
            price: state.price,
            image: getImageUrl,
            description: state.description,
            multipleImage: imagesUrl,
            moreDescription: state.moreDescription));
      } catch (ex) {
        emit(state.copyWith(error: ex.toString(), isDataValid: false));
      } finally {
        emit(state.copyWith(isLoading: false));
      }
      emit(state.copyWith(isSubmitSuccess: true));
    } else {
      emit(state.copyWith(error: "Fill proper data"));
    }
  }

  _onUpdateData(
      OnUpdateShoppingData event, Emitter<ShoppingformState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final db = DatabaseRepositoryImpl();
      final shopping = ShoppingModel();
      String getImageUrl = "";
      if (state.image.path.isNotEmpty) {
        final storageRefImage = FirebaseStorage.instance
            .ref()
            .child("shopping_image")
            .child('${state.image.path}.jpg');

        await storageRefImage.putFile(state.image);

        getImageUrl = await storageRefImage.getDownloadURL();
      }

      List<String> imagesUrl = [];
      if (state.multipleImage.isNotEmpty) {
        for (var image in state.multipleImage) {
          final storageRefImages = FirebaseStorage.instance
              .ref()
              .child("shopping_images")
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          await storageRefImages.putFile(image);
          final getImagesUrl = await storageRefImages.getDownloadURL();
          imagesUrl.add(getImagesUrl);
        }
      }
      final data = await db
          .retrieveSingleShoppingData(shopping.copyWith(uid: event.uid));
      await db.updateShoppingData(
        shopping.copyWith(
            uid: event.uid,
            name: state.pname == "" ? data.name : state.pname,
            price: state.price == 0 ? data.price : state.price,
            description:
                state.description == "" ? data.description : state.description,
            moreDescription: state.moreDescription == ""
                ? data.moreDescription
                : state.moreDescription,
            image: getImageUrl == "" ? data.image : getImageUrl,
            multipleImage: imagesUrl.isEmpty ? data.multipleImage : imagesUrl),
      );
    } catch (ex) {
      emit(state.copyWith(error: ex.toString(), isDataValid: false));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
    emit(state.copyWith(isSubmitSuccess: true));
  }
}
