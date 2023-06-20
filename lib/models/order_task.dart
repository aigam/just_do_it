import 'package:just_do_it/models/review.dart';

class OrderTask {
  int? id;
  int? chatId;
  String? name;
  String? description;
  Owner? owner;

  OrderTask({
    this.id,
    this.chatId,
    this.name,
    this.description,
    this.owner,
  });

  factory OrderTask.fromJson(Map<String, dynamic> json) => OrderTask(
        id: json["id"],
        chatId: json["chat_id"],
        name: json["name"],
        description: json["description"],
        owner: Owner.fromJson(json["owner"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "owner": owner,
      };
}

class Currency {
  bool isSelect;
  int? id;
  String? name;
  String? shortName;

  Currency(this.isSelect, {required this.id, required this.name, required this.shortName});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(false, id: json['id'], name: json['name'], shortName: json['short_name']);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
      };
}

class Owner {
  int? id;
  String? firstname;
  String? lastname;
  String? photo;
  String? cv;
  int? isLiked;
  double? ranking;
  bool? isPassportExist;
  int? countOrdersCreate;
  String? activity;
  List<String> listPhoto;
  int? balance;
  List<ownerActivities>? activities;
  int? countOrdersComplete;
  List<ReviewsDetail>? reviews;
  ReviewsDetail? lastReviews;
  Owner({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
    this.balance,
    this.cv,
    this.ranking,
    this.activities,
    this.isPassportExist,
    this.countOrdersCreate,
    this.activity,
    this.isLiked,
    this.listPhoto = const [],
    this.countOrdersComplete,
    this.reviews,
    this.lastReviews,

  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    List<String> listPhoto = [];
    if (json['images'] != null) {
      for (var element in json['images']) {
        listPhoto.add(element['image']);
      }
    }
    List<ownerActivities> activities = [];
    if (json['activities'] != null) {
      for (var element in json['activities']) {
        activities.add(ownerActivities.fromJson(element));
      }
    }
    List<ReviewsDetail> reviews = [];
    if (json['reviews'] != null) {
      for (var element in json['reviews']) {
        reviews.add(ReviewsDetail.fromJson(element));
      }
    }
    return Owner(
      lastReviews: json['last_review'] == null ? null : ReviewsDetail.fromJson(json['last_review']),
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      photo: json["photo"],
      cv: json["CV"],
      activities: activities,
      balance: json["balance"],
      ranking: json["ranking"],
      isLiked: json["is_liked"],
      isPassportExist: json["is_passport_exist"],
      countOrdersCreate: json["count_orders_create"],
      activity: json["activity"],
      countOrdersComplete: json["count_orders_complete"],
      listPhoto: listPhoto,
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "photo": photo,
        "is_liked": isLiked,
      };
}

class ownerActivities {
  bool isSelect;
  int id;
  String? description;
  String? photo;
  List<ownerSubcategory> subcategory;
  List<String> selectSubcategory = [];

  ownerActivities(this.isSelect, this.id, this.description, this.photo, this.subcategory);

  factory ownerActivities.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    String? photo = data['photo'];
    List<ownerSubcategory> subcategory = [];
    if (data['subcategories'] != null) {
      for (var element in data['subcategories']) {
        subcategory.add(ownerSubcategory.fromJson(element));
      }
    }
    return ownerActivities(false, id, description, photo, subcategory);
  }
}

class ownerSubcategory {
  bool isSelect;
  int id;
  String? description;

  ownerSubcategory(this.isSelect, {required this.id, required this.description});

  factory ownerSubcategory.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    return ownerSubcategory(false, id: id, description: description);
  }
}
