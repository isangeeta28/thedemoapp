import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String imageUrl;
  final String iconUrl;

  const Experience({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      name: json['name'],
      tagline: json['tagline'],
      description: json['description'],
      imageUrl: json['image_url'],
      iconUrl: json['icon_url'],
    );
  }

  @override
  List<Object?> get props => [id, name, tagline, description, imageUrl, iconUrl];
}