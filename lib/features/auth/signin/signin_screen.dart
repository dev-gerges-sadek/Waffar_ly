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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController    = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ بدل primaryBlue — بيستخدم لون الـ scaffold من الـ theme
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(24),
          ),
          child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Welcome Back!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              } else if (state is ResetPasswordSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check your email to reset password'),
                    backgroundColor: Colors.blue,
                  ),
                );
              } else if (state is LoginErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is ResetPasswordErrorState) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    // ✅ TitleHeader بيعرض اسم التطبيق الصح
                    const TitleHeaderWidget(text: 'Have another productive day!'),
                    SizedBox(height: context.h(32)),
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
                      icon: Icons.email,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Email is required'
                          : null,
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
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 8)
                          ? '8+ characters required'
                          : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<AuthCubit>()
                              .resetPassword(emailController.text);
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: context.sp(12),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(16)),
                    state is LoginLoadingState ||
                            state is ResetPasswordLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: CustomCategoryButton(
                              text: 'Login',
                              onTap: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  context.read<AuthCubit>().login(
                                        emailController.text,
                                        passwordController.text,
                                      );
                                }
                              },
                            ),
                          ),
                    SizedBox(height: context.h(24)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: context.sp(14),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.signup),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: context.sp(14),
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(32)),
                    const OrDivider(text: 'in'),
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
