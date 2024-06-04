import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/authentication/domain/create_user_params.dart';
import 'package:trainer_app/features/user/data/user_repository.dart';
import 'package:trainer_app/features/user/domain/app_user.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;

    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userCredential.user?.uid)
    //     .set({'email': email, 'type': type, 'id': userCredential.user?.uid});
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}

@Riverpod(keepAlive: true)
Future<void> createUser(CreateUserRef ref, UserParams params) async {
  final authProvider = ref.read(authRepositoryProvider);

  final credential = await authProvider.createUserWithEmailAndPassword(
    email: params.email,
    password: params.password,
  );

  AppUser user = AppUser(
    id: credential.user!.uid,
    email: params.email,
    type: params.type,
    name: params.name
  );

  final userRepository = ref.read(userRepositoryProvider);
  await userRepository.setUser(user);
}


@riverpod
String? userId(UserIdRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser?.uid;
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

