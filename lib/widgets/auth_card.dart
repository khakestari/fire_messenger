import 'dart:io';
import 'dart:ui';
import '../widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    AuthMode mode,
  ) submitFn;
  final _isLoading;
  AuthCard(this.submitFn, this._isLoading);
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };

  final _passwordController = TextEditingController();

  File? _userImageFile;

  late AnimationController _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, -1.5), end: const Offset(0.0, 0.0))
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _opacityAnimation!.addListener(() => setState(() {}));
    _opacityAnimation!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && _authMode == AuthMode.Signup) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You didn\'t pick an image!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      // print('here is reading');
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    widget.submitFn(
      _authData['email']!.trim(),
      _authData['password']!.trim(),
      _authData['username']!.trim(),
      _authMode,
    );
  }

  void _submitImage(File? image) {
    _userImageFile = image;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 440 : 350,
          constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.Signup ? 440 : 350,
          ),
          // height: _heightAnimation!.value.height,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFF00449B).withOpacity(0.05),
          ),
          width: deviceSize.width * 0.75,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation!,
                      child: SlideTransition(
                          position: _slideAnimation!,
                          child: UserImagePicker(_submitImage)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      labelText: 'E-Mail',
                      filled: true,
                      fillColor: Color(0x00C6B8B8),
                      suffixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation!,
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            labelText: 'Username',
                            // filled: true,
                            fillColor: Color(0x00C6B8B8),
                            suffixIcon: Icon(Icons.account_circle),
                          ),
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter at least 4 characters.';
                                  }
                                  return null;
                                }
                              : null,
                          onSaved: (value) {
                            _authData['username'] = value!;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      labelText: 'Password',
                      filled: true,
                      fillColor: Color(0x00C6B8B8),
                      suffixIcon: Icon(Icons.password),
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation!,
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            labelText: 'Password Confirm',
                            filled: true,
                            fillColor: Color(0x00C6B8B8),
                            suffixIcon: Icon(Icons.repeat),
                          ),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Password not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget._isLoading)
                    const CircularProgressIndicator.adaptive()
                  else
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color(0xfFfb6334).withOpacity(0.75)),
                      onPressed: _submit,
                      child: Text(
                        _authMode == AuthMode.Login ? 'Log in' : 'Sign up ',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _switchAuthMode,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent, // Color(0xFF363636),
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // textStyle: TextStyle(),
                    ),
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'Don\'t have an account? Sign up' : 'Have an account already? Log in'}',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
