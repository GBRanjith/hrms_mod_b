import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_mod_b/core/storage/preference_service.dart';
import 'package:hrms_mod_b/core/theme/app_scaling.dart';
import 'package:hrms_mod_b/core/utils/app_decoration.dart';
import 'package:hrms_mod_b/core/utils/date_extension.dart';
import 'package:hrms_mod_b/features/employee/data/models/employee_model.dart';

import '../../../../app/router/route_names.dart';
import '../../../claim/data/claim_repo.dart';
import '../../../claim/data/models/claim_model.dart';
import '../../../claim/presentation/widgets/claim_item.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final EmployeeModel employee;
  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final List<ClaimModel> claims = ClaimRepository.getEmployeeClaims(
      employee.id ?? "",
    );
    return Scaffold(
      appBar: AppBar(title: Text("Employee Detail"), centerTitle: false),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(AppScaling.space12),
            padding: EdgeInsets.all(AppScaling.space12),
            width: MediaQuery.sizeOf(context).width,
            decoration: AppDecoration.cardOutlined(colorScheme),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: AppScaling.space40,
                  child: Text(
                    employee.name?.isNotEmpty == true
                        ? employee.name![0].toUpperCase()
                        : '',
                    style: textTheme.displayMedium,
                  ),
                ),
                SizedBox(height: AppScaling.space8),
                Text(
                  employee.name ?? "",
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  employee.designation ?? "",
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  (employee.department?.label ?? "").toUpperCase(),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
            child: Text(
              "Contact Information",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppScaling.space12),
            decoration: AppDecoration.cardOutlined(colorScheme),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.email_outlined),
                  title: Text("Email"),
                  subtitle: Text(
                    employee.email ?? "",
                    style: textTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.phone),
                  title: Text("Phone Number"),
                  subtitle: Text(
                    employee.phoneNumber ?? "-",
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppScaling.space12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppScaling.space16),
            child: Text(
              "Work Information",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppScaling.space12),
            decoration: AppDecoration.cardOutlined(colorScheme),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.supervisor_account),
                  title: Text("Reporting Manager"),
                  subtitle: Text(
                    employee.reportingManager ?? "",
                    style: textTheme.bodyLarge,
                  ),
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.calendar_month_outlined),
                  title: Text("Date of Joining"),
                  subtitle: Text(
                    employee.dateOfJoining?.toShortDate ?? "-",
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppScaling.space12),
          if (PreferenceService.employeeId == employee.id) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppScaling.space16,
              ),
              child: Text(
                "Expense Claims",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: claims.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(AppScaling.space16),
              itemBuilder: (context, index) {
                return ClaimItem(
                  claim: claims[index],
                  onLongPress: null,
                  onTap: () {
                    context.pushNamed(
                      RouteNames.claimDetail,
                      pathParameters: {'id': claims[index].id ?? ''},
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
