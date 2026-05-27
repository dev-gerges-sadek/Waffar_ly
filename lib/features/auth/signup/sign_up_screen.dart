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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailCtrl    = TextEditingController();
  final _nameCtrl     = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      ctx.read<AuthCubit>().signUp(
            _emailCtrl.text,
            _passwordCtrl.text,
            _nameCtrl.text,
          );
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
                if (state is SignUpSuccessState) {
                  _showSnack(ctx, '${l10n.welcomeTo}${l10n.appName}',
                      SHColors.lightSuccessColor);
                  Navigator.pushNamedAndRemoveUntil(
                      ctx, AppRoutes.signin, (_) => false);
                } else if (state is SignUpErrorState) {
                  _showSnack(ctx, state.error, SHColors.darkErrorColor);
                }
              },
              builder: (ctx, state) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      title: l10n.createAccount,
                      subtitle: l10n.appName,
                    ),
                    SizedBox(height: context.h(32)),

                    // ── Name ──────────────────────────────────────────
                    _Label(l10n.name),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: _nameCtrl,
                      hintText: l10n.name,
                      icon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.name : null,
                    ),
                    SizedBox(height: context.h(16)),

                    // ── Email ─────────────────────────────────────────
                    _Label(l10n.email),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: _emailCtrl,
                      hintText: 'example@gmail.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.errInvalidEmail;
                        if (!v.contains('@')) return l10n.errInvalidEmail;
                        return null;
                      },
                    ),
                    SizedBox(height: context.h(16)),

                    // ── Password ──────────────────────────────────────
                    _Label(l10n.password),
                    SizedBox(height: context.h(8)),
                    CustomFormTextField(
                      controller: _passwordCtrl,
                      hintText: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) =>
                          (v == null || v.length < 8) ? l10n.errWeakPassword : null,
                    ),
                    SizedBox(height: context.h(32)),

                    // ── Create button ─────────────────────────────────
                    state is SignUpLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : CustomCategoryButton(
                            text: l10n.createAccount,
                            onTap: () => _submit(ctx),
                          ),
                    SizedBox(height: context.h(16)),

                    // ── Sign-in link ──────────────────────────────────
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(l10n.hasAccount,
                              style: TextStyle(
                                fontSize: context.sp(13),
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.signin),
                            child: Text(
                              l10n.signIn,
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
                    SizedBox(height: context.h(24)),
                    const OrDivider(mode: 'up'),
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

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext ctx) => Text(
        text,
        style: TextStyle(
          fontSize: ctx.sp(13),
          fontWeight: FontWeight.w500,
          color: Theme.of(ctx).colorScheme.onSurface,
        ),
      );
}
