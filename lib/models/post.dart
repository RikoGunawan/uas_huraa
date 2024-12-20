class Post {
  final String id;
  String name;
  String description;
  final String imageUrl;
  final String userImageUrl;
  int likes;
  int shares;
  final String userId; // Tambahkan user_id
  double? width; // Tambahkan properti width
  double? height; // Tambahkan properti height
  double? aspectRatio; // Tambahkan properti aspectRatio
  bool isLiked; // Tambahkan properti untuk status like

  Post({
    required this.id,
    required this.name,
    this.description = '',
    required this.imageUrl,
    required this.userImageUrl,
    this.likes = 0,
    this.shares = 0,
    required this.userId,
    this.width,
    this.height,
    this.aspectRatio,
    this.isLiked = false,
  }) {
    if (width != null && height != null) {
      aspectRatio = width! / height!;
    } else {
      aspectRatio = 1.0; // Default aspect ratio
    }
  }

  // Konversi JSON ke objek Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      userImageUrl: json['user_image_url'],
      likes: json['likes'],
      shares: json['shares'],
      userId: json['user_id'],
      width: json['width']?.toDouble(),
      height: json['height']?.toDouble(),
      isLiked: json['is_liked'] ?? false, // Ambil status liked dari JSON
    );
  }

  // Konversi objek Post ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'user_image_url': userImageUrl,
      'likes': likes,
      'shares': shares,
      'user_id': userId,
      'width': width,
      'height': height,
      'is_liked': isLiked, // Sertakan isLiked dalam JSON
    };
  }
}
