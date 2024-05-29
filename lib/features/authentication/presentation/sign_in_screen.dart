import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/authentication/domain/create_user_params.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropDownState = ref.watch(dropDownStateProvider);
    final signInState = ref.watch(signInStateProvider);
    final authProvider = ref.read(authRepositoryProvider);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trainer App'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: signInState.selectedOption == 'Login'
                  ? [
                      const Text(
                        'Don\'t have an account ',
                        style: TextStyle(fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () => signInState.setSelectedOption('Register'),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 25, color: Colors.blue),
                        ),
                      ),
                    ]
                  : [
                      const Text(
                        'Already registered? ',
                        style: TextStyle(fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () => signInState.setSelectedOption('Login'),
                        child: const Text(
                          'Log in',
                          style: TextStyle(fontSize: 25, color: Colors.blue),
                        ),
                      ),
                    ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0), // Add some vertical spacing
                  TextField(
                    controller: passwordController,
                    obscureText: true, // Hide the entered text
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  signInState.selectedOption == 'Register'
                      ? DropdownButton<String>(
                          value: dropDownState.selectedOption,
                          onChanged: dropDownState.setSelectedOption,
                          items: <String>['trainer', 'client']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      : const SizedBox.shrink(),
                  // Add some vertical spacing
                  ElevatedButton(
                    onPressed: () async {
                      if (signInState.selectedOption == "Login") {
                        await authProvider.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      } else {
                        final params = UserParams(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          type: dropDownState.selectedOption,
                        );

                        // Read the provider with the given parameters
                        ref.read(createUserProvider(params));
                      }
                    },
                    child: Text(signInState.selectedOption == 'Login'
                        ? 'Login'
                        : 'Register'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class DropDownState extends ChangeNotifier {
  String _selectedOption = 'trainer';

  String get selectedOption => _selectedOption;

  void setSelectedOption(String? option) {
    _selectedOption = option ?? 'trainer';
    notifyListeners(); // Notify listeners of the change
  }
}

final dropDownStateProvider = ChangeNotifierProvider<DropDownState>((ref) {
  return DropDownState();
});

class SignInState extends ChangeNotifier {
  String _selectedOption = 'Login';

  String get selectedOption => _selectedOption;

  void setSelectedOption(String? option) {
    _selectedOption = option ?? 'Login';
    notifyListeners(); // Notify listeners of the change
  }

  void signInOrRegister() {}
}

final signInStateProvider = ChangeNotifierProvider<SignInState>((ref) {
  return SignInState();
});
