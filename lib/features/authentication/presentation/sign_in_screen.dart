import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropDownState = ref.watch(dropDownStateProvider);
    final signInState = ref.watch(signInStateProvider);
    final firebaseAuth = ref.read(firebaseAuthProvider);
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
                  const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0), // Add some vertical spacing
                  const TextField(
                    obscureText: true, // Hide the entered text
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  signInState.selectedOption == 'Register'
                      ? DropdownButton<String>(
                          value: dropDownState.selectedOption,
                          onChanged: dropDownState.setSelectedOption,
                          items: <String>['Trainer', 'Client']
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
                      signInState._selectedOption == "Login"
                          ? await firebaseAuth.signInWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim())
                          : await firebaseAuth.createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
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
  String _selectedOption = 'Trainer';

  String get selectedOption => _selectedOption;

  void setSelectedOption(String? option) {
    _selectedOption = option ?? 'Trainer';
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
