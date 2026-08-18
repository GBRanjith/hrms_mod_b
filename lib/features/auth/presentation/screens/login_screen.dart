import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_mod_b/core/widgets/app_button.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../../../core/widgets/app_textfield.dart';
import '../../data/models/auth_input_model.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? "Login failed"),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
              if (state.status.isSuccess && state.nextRoute != null) {
                context.goNamed(state.nextRoute!);
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: AppScaling.space32),
                    Icon(
                      Icons.group,
                      size: MediaQuery.sizeOf(context).width / 2,
                    ),
                    Text(
                      AppConstants.appName,
                      style: textTheme.displaySmall?.copyWith(
                        color: colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Sign in to continue", style: textTheme.bodyLarge),
                    Padding(
                      padding: const EdgeInsets.all(AppScaling.space16),
                      child: AppTextField(
                        title: "Employee ID",
                        isRequired: true,
                        hintText: "Enter your employee ID",
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Employee ID is required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<AuthBloc>().add(
                            LoginOnFieldChanged(
                              field: LoginField.userName,
                              value: value,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppScaling.space16),
                      child: AppTextField(
                        title: "Password",
                        isRequired: true,
                        fieldType: FieldType.password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<AuthBloc>().add(
                            LoginOnFieldChanged(
                              field: LoginField.password,
                              value: value,
                            ),
                          );
                        },
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              LoginOnChangeHidePassword(!state.hidePassword),
                            );
                          },
                        ),
                        obscureText: state.hidePassword,
                      ),
                    ),
                    const SizedBox(height: AppScaling.space32),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppScaling.space16,
                      ),
                      child: AppButton(
                        text: "Login",
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<AuthBloc>().add(
                              LoginSubmitted(state.input ?? AuthInputModel()),
                            );
                          }
                        },
                        isLoading: state.status.isLoading,
                      ),
                    ),
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
