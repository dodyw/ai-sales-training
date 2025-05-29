class UserProfile {
  final String name;
  final String company;
  final String productType;
  final String experience;

  UserProfile({
    required this.name,
    required this.company,
    required this.productType,
    required this.experience,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      company: json['company'],
      productType: json['productType'],
      experience: json['experience'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company': company,
      'productType': productType,
      'experience': experience,
    };
  }
}
