import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app/app_routes.dart';
import '../../../../core/helper/extensions/media_query.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/sh_colors.dart';
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
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      ctx.read<AuthCubit>().login(_emailCtrl.text, _passwordCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => AuthCubit.withL10n(l10n),
      child: Scaffold(
        backgroundColor: SHColors.background(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: context.w(24),
              vertical: context.h(24),
            ),
            child: BlocConsumer<AuthCubit, AuthStates>(
              listener: (ctx, state) {
                if (state is LoginSuccessState) {
                  _showSnack(ctx, '${l10n.welcomeTo}${l10n.appName}',
                      SHColors.lightSuccessColor);
                  Navigator.pushNamedAndRemoveUntil(
                      ctx, AppRoutes.home, (_) => false);
                } else if (state is ResetPasswordSuccessState) {
                  _showSnack(ctx, l10n.forgotPass, SHColors.primary(ctx));
                } else if (state is LoginErrorState) {
                  _showSnack(ctx, state.error,
                      SHColors.darkErrorColor);
                } else if (state is ResetPasswordErrorState) {
                  _showSnack(ctx, state.error,
                      SHColors.darkErrorColor);
                }
              },
              builder: (ctx, state) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Logo ──────────────────────────────────────────
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

                    TitleHeaderWidget(
                      title: l10n.appName,
                      subtitle: l10n.welcomeTo + l10n.appName,
                    ),
                    SizedBox(height: context.h(32)),

                    // ── Email ─────────────────────────────────────────
                    _FieldLabel(l10n.email),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: _emailCtrl,
                      hintText: 'example@gmail.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || v.isEmpty)
                          ? l10n.errInvalidEmail : null,
                    ),
                    SizedBox(height: context.h(16)),

                    // ── Password ──────────────────────────────────────
                    _FieldLabel(l10n.password),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: _passwordCtrl,
                      hintText: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) => (v == null || v.length < 6)
                          ? l10n.errWeakPassword : null,
                    ),

                    // ── Forgot password ───────────────────────────────
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () => ctx
                            .read<AuthCubit>()
                            .resetPassword(_emailCtrl.text),
                        child: Text(
                          l10n.forgotPass,
                          style: TextStyle(
                            fontSize: context.sp(12),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(8)),

                    // ── Login button ──────────────────────────────────
                    state is LoginLoadingState ||
                            state is ResetPasswordLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: CustomCategoryButton(
                              text: l10n.login,
                              onTap: () => _submit(ctx),
                            ),
                          ),
                    SizedBox(height: context.h(24)),

                    // ── Sign-up link ──────────────────────────────────
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(l10n.noAccount,
                              style: TextStyle(
                                fontSize: context.sp(13),
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.signup),
                            child: Text(
                              l10n.signUp,
                              style: TextStyle(
                                fontSize: context.sp(13),
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.h(32)),
                    const OrDivider(mode: 'in'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext ctx, String msg, Color bg) =>
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: bg),
      );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: context.sp(13),
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      );
}
