/// Seller model representing a seller in the Aurora platform
///
/// **SECURITY**: This model does NOT contain password fields.
/// Passwords are handled exclusively by Supabase Auth and never stored locally.
class Seller {
  final int? id;
  final String userId;
  final String firstname;
  final String secondname;
  final String thirdname;
  final String fourthname;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String currency;
  final String accountType;
  final bool isVerified;
  final double? latitude;
  final double? longitude;
  final String? chatRoomId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Seller({
    this.id,
    required this.userId,
    required this.firstname,
    required this.secondname,
    required this.thirdname,
    required this.fourthname,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    this.currency = 'EGP',
    this.accountType = 'seller',
    this.isVerified = false,
    this.latitude,
    this.longitude,
    this.chatRoomId,
    this.createdAt,
    this.updatedAt,
  });

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'] as int?,
      userId: map['user_id'] as String? ?? '',
      firstname: map['firstname'] as String? ?? '',
      secondname: map['secondname'] as String? ?? '',
      thirdname: map['thirdname'] as String? ?? '',
      fourthname: map['fourthname'] as String? ?? map['forthname'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      location: map['location'] as String? ?? '',
      currency: map['currency'] as String? ?? 'EGP',
      accountType: map['account_type'] as String? ?? 'seller',
      isVerified: (map['is_verified'] == 1 || map['is_verified'] == true),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      chatRoomId: map['chat_room_id'] as String?,
      createdAt: map['created_at'] != null 
          ? DateTime.tryParse(map['created_at'] as String) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.tryParse(map['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'firstname': firstname,
      'secondname': secondname,
      'thirdname': thirdname,
      'fourthname': fourthname,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'currency': currency,
      'account_type': accountType,
      'is_verified': isVerified ? 1 : 0,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (chatRoomId != null) 'chat_room_id': chatRoomId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  String get displayName => fullName.isNotEmpty ? fullName : firstname;

  @override
  String toString() => 'Seller(id: $id, email: $email, name: $displayName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Seller && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}