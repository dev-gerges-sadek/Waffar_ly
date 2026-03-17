import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffar_ly_app/core/app/app_routes.dart';
import 'package:waffar_ly_app/core/helper/extensions/media_query.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/custom_category_button.dart';
import '../widgets/custom_form_text_field.dart';
import '../widgets/or_divider.dart';
import '../widgets/title_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController    = TextEditingController();
    nameController     = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ بدل primaryBlue
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(24),
          ),
          child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is SignUpSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.signin, // ✅ إصلاح typo
                  (route) => false,
                );
              } else if (state is SignUpErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: context.w(40),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: const Image(
                          image: AssetImage('assets/images/Logo.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(24)),
                    const TitleHeaderWidget(
                      text: 'Create an account and join us now!',
                    ),
                    SizedBox(height: context.h(24)),
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: context.sp(14),
                        color: Theme.of(context).colorScheme.onSurface, // ✅
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: nameController,
                      hintText: 'Enter your name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.h(16)),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: context.sp(14),
                        color: Theme.of(context).colorScheme.onSurface, // ✅
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: emailController,
                      hintText: 'example@gmail.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) return 'Invalid email format';
                        return null;
                      },
                    ),
                    SizedBox(height: context.h(16)),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: context.sp(14),
                        color: Theme.of(context).colorScheme.onSurface, // ✅
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: passwordController,
                      hintText: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.h(32)),
                    state is SignUpLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : CustomCategoryButton(
                            text: 'Create Account',
                            onTap: () {
                              if (formKey.currentState?.validate() ?? false) {
                                context.read<AuthCubit>().signUp(
                                      emailController.text,
                                      passwordController.text,
                                      nameController.text,
                                    );
                              }
                            },
                          ),
                    SizedBox(height: context.h(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: context.sp(14),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.signin),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: context.sp(14),
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(24)),
                    const OrDivider(text: 'Up'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
