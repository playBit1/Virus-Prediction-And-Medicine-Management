import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:medicare/database/authenticate.dart';
import 'package:test/test.dart';

void main() {
  test('Test Create account', (() {
    final user = MockUser(
      isAnonymous: false,
      uid: 'testID',
      email: 'test@sampledomain.com',
      displayName: 'Sample',
    );

    final auth = MockFirebaseAuth(mockUser: user);

    try {
      final u = MockFirebaseAuth().createUserWithEmailAndPassword(
          email: 'asdsda', password: 'asdasdwe');
    } on FirebaseAuthException catch (e) {
      expect(e, false);
    }
  }));

  test('Test Login account', (() {}));

  test('Test update username', (() {}));
}
