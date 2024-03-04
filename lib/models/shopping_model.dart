import 'package:cloud_firestore/cloud_firestore.dart';

enum ShoppingStatus{pending,cancel,delivered,dispatch}

class ShoppingModel {
  ShoppingModel({this.shopId, this.date, this.shoppingStatus, this.name, this.price, this.image, this.description,
      this.multipleImage, this.moreDescription, this.uid});
  String? uid;
  final String? shopId;
  final String? name;
  final double? price;
  final String? image;
  final String? description;
  final List<dynamic>? multipleImage;
  final String? moreDescription;
  final String? shoppingStatus;
  final Timestamp? date;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'multipleImage': multipleImage,
      'moreDescription': moreDescription,
      'status':shoppingStatus,
      'date_time':date,
      'shopId':shopId
    };
  }

  ShoppingModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>?> doc)
      : uid = doc.id,
        name = doc.data()?['name'],
        price = doc.data()?['price'],
        image = doc.data()?['image'],
        description = doc.data()?['description'],
        multipleImage = doc.data()?['multipleImage'],
        shoppingStatus = doc.data()?['status'],
        moreDescription = doc.data()?['moreDescription'],
        shopId = doc.data()?['shopId'],
        date = doc.data()?['date_time'];

  ShoppingModel copyWith({
    String? uid,
    String? name,
    double? price,
    String? image,
    String? description,
    List<dynamic>? multipleImage,
    String? moreDescription,
    String? shoppingStatus,
    Timestamp? date,
    String? shopId
  }){
    return ShoppingModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      price: price ?? this.price,
      date: date ?? this.date,
      shopId: shopId ?? this.shopId,
      image: image ?? this.image,
      shoppingStatus: shoppingStatus ?? this.shoppingStatus,
      description: description ?? this.description,
      multipleImage: multipleImage ?? this.multipleImage,
      moreDescription: moreDescription ?? this.moreDescription
    );
  }
}
