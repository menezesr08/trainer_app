import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/authentication/domain/create_user_params.dart';
import 'package:trainer_app/features/user/data/user_repository.dart';
import 'package:trainer_app/features/user/domain/app_user.dart';
import 'package:trainer_app/providers/auth_providers.dart';
import 'package:trainer_app/providers/firestore_providers.dart';
import 'package:trainer_app/providers/profile_providers.dart';
part 'user_providers.g.dart';

@Riverpod(keepAlive: true)
String? userId(UserIdRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser?.uid;
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
      name: params.name);

  final userRepository = ref.read(userRepositoryProvider);
  await userRepository.setUser(user);
}

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
Future<AppUser?> getUser(GetUserRef ref) {
  final userId = ref.watch(authRepositoryProvider).currentUser!.uid;
  final userRepo = ref.watch(userRepositoryProvider);

  ref.watch(profileRefreshNotifierProvider);
  return userRepo.getUser(userId);
}

