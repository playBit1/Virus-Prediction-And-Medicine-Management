import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createAccWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    currentUser?.updateDisplayName(name);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String? getUid() {
    return currentUser?.uid;
  }

  void updateUserName(String name) {
    currentUser?.updateDisplayName(name);
  }

  String? getCurrentUserName() {
    return currentUser?.displayName;
  }
}
