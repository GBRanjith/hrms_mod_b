import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_mod_b/core/utils/date_extension.dart';
import 'package:hrms_mod_b/core/widgets/app_button.dart';
import 'package:hrms_mod_b/core/widgets/app_filter_chips.dart';
import 'package:hrms_mod_b/core/widgets/app_textfield.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_scaling.dart';
import '../../../../core/utils/extension.dart';
import '../../domine/enums/expense_category_enum.dart';
import '../form_bloc.dart/claim_form_bloc.dart';
import '../form_bloc.dart/claim_form_event.dart';
import '../form_bloc.dart/claim_form_state.dart';
import '../widgets/receipt_picker.dart';

class ClaimFormScreen extends StatelessWidget {
  const ClaimFormScreen({super.key, this.claimId});

  final String? claimId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClaimFormBloc()..add(ClaimFormStarted(claimId: claimId)),
      child: const _ClaimFormView(),
    );
  }
}

class _ClaimFormView extends StatefulWidget {
  const _ClaimFormView();

  @override
  State<_ClaimFormView> createState() => _ClaimFormViewState();
}

class _ClaimFormViewState extends State<_ClaimFormView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _prefilled = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _prefill(ClaimFormState state) {
    if (_prefilled || !state.isEditing) return;

    _amountController.text =
        state.claim.amount?.formatAmount(symbol: false) ?? '';
    _descriptionController.text = state.claim.description ?? '';
    _prefilled = true;
  }

  Future<void> _pickDate(BuildContext context, ClaimFormState state) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: state.date,
      firstDate: DateTime(now.year - 2, now.month, now.day),
      lastDate: DateTime(now.year, now.month + 2, now.day),
    );
    if (picked == null || !context.mounted) return;
    context.read<ClaimFormBloc>().add(ClaimFormDateChanged(picked));
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<ClaimFormBloc>().add(
      ClaimFormSubmitted(
        amount: _amountController.text.asDouble() ?? 0,
        description: _descriptionController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<ClaimFormBloc, ClaimFormState>(
      listener: (context, state) {
        _prefill(state);

        if (state.status.isSuccess) {
          final message = state.message ?? 'Saved';
          if (state.isEditing) {
            context.pop();
          } else {
            context.pushReplacementNamed(
              RouteNames.claimDetail,
              pathParameters: {'id': state.claim.id ?? ''},
            );
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
          return;
        }
        if (state.message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isEditing ? 'Edit Claim' : 'New Claim'),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppScaling.space16),
              children: [
                Text("Category", style: textTheme.labelLarge),
                AppFilterChips<ExpenseCategory>(
                  items: ExpenseCategory.values,
                  selected: state.category,
                  labelOf: (item) => item.label,

                  onSelected: (value) {
                    context.read<ClaimFormBloc>().add(
                      ClaimFormCategoryChanged(value!),
                    );
                  },
                ),
                const SizedBox(height: AppScaling.space16),
                AppTextField(
                  title: "Expense Amount",
                  prefixIcon: Icon(Icons.currency_rupee_outlined),
                  fieldType: FieldType.number,
                  hintText: "1200",
                  controller: _amountController,
                  isRequired: true,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppScaling.space12),
                AppTextField(
                  title: "Expense date",
                  readOnly: true,
                  onTap: () => _pickDate(context, state),
                  hintText: "",
                  controller: TextEditingController(
                    text: state.date.toShortDate,
                  ),
                  isRequired: true,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                  prefixIcon: Icon(Icons.event_outlined),
                ),
                const SizedBox(height: AppScaling.space12),
                AppTextField(
                  title: "Description & Purpose",
                  prefixIcon: Icon(Icons.note_alt_sharp),
                  hintText: "Client meeting travel — Chennai to Bengaluru",
                  controller: _descriptionController,
                  maxLines: 3,
                  fieldType: FieldType.multiline,
                  maxLength: 400,
                ),

                const SizedBox(height: AppScaling.space8),
                ReceiptPicker(
                  file: state.pickedReceipt,
                  fileName: state.claim.receiptFileName,
                  onChanged: (file) => context.read<ClaimFormBloc>().add(
                    ClaimFormReceiptChanged(file),
                  ),
                ),

                const SizedBox(height: AppScaling.space24),
                AppButton(
                  text: state.isEditing ? 'Save changes' : 'Submit claim',
                  isLoading: state.status.isLoading,
                  onPressed: _submit,
                ),
                SizedBox(height: AppScaling.space24),
              ],
            ),
          ),
        );
      },
    );
  }
}
