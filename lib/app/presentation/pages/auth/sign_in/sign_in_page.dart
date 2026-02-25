import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_dialog.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_loading.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_primary_button.dart';
import 'package:hubla_weather/app/core/design_system/widgets/hubla_text_input.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final textStyles = context.hublaTextStyles;
    final shape = context.hublaShape;
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SignInCubit>();
    return BlocPresentationListener<SignInCubit, SignInPresentationEvent>(
      listener: (context, event) => switch (event) {
        ShowLoadingEvent() => HublaLoading.show(context),
        HideLoadingEvent() => HublaLoading.hide(context),
        ErrorEvent(:final errorMessage) => HublaDialog.showError(
          context,
          title: AppLocalizations.of(context).error,
          message: errorMessage,
        ),
        SuccessEvent() => context.go(HublaRoute.cities.path),
      },
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) => Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: colors.backgroundGradient),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colors.sky,
                          borderRadius: BorderRadius.circular(shape.extraLarge),
                          boxShadow: [
                            BoxShadow(
                              color: colors.sky.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(Icons.wb_sunny_rounded, size: 44, color: colors.sun),
                      ),
                      SizedBox(height: spacing.lg),
                      Text(
                        l10n.welcomeBack,
                        style: textStyles.headlineMedium.copyWith(color: colors.onSurface),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        l10n.signInSubtitle,
                        style: textStyles.bodyMedium.copyWith(color: colors.onSurfaceVariant),
                      ),
                      SizedBox(height: spacing.xl),
                      Container(
                        padding: EdgeInsets.all(spacing.lg),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(shape.extraLarge),
                          boxShadow: [
                            BoxShadow(
                              color: colors.onSurface.withValues(alpha: 0.08),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HublaTextInput(
                              label: l10n.email,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(Icons.email_outlined, color: colors.gray50),
                              onChanged: cubit.updateEmail,
                            ),
                            SizedBox(height: spacing.md),
                            HublaTextInput(
                              label: l10n.password,
                              obscureText: state.obscurePassword,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icon(Icons.lock_outline_rounded, color: colors.gray50),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: colors.gray50,
                                ),
                                onPressed: cubit.togglePasswordVisibility,
                              ),
                              onChanged: cubit.updatePassword,
                            ),
                            SizedBox(height: spacing.lg),
                            HublaPrimaryButton(
                              label: l10n.signIn,
                              isEnabled: state.hasValidInput,
                              onPressed: cubit.signIn,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
