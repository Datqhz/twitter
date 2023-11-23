class UserDataFirebase{
  final String uid;
  final String email;
  final String displayName;
  final String account;

  UserDataFirebase({required this.uid, required this.email, required this.displayName, required this.account});
}

class UserAuth{
  final String uid;

  UserAuth({required this.uid});
}