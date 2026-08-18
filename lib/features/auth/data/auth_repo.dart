import '../../../core/constants/app_constants.dart';
import '../../../core/enums/status.dart';
import '../../../core/utils/repo_response_model.dart';
import 'models/auth_input_model.dart';

class AuthRepository {
  static Future<RepoResult> login(AuthInputModel input) async {
    if (input.userName == AppConstants.demoEmployeeId &&
        input.password == AppConstants.demoPassword) {
      return RepoResult(status: Status.success, message: "Login successful");
    } else {
      return RepoResult(status: Status.failure, message: "Invalid credentials");
    }
  }
}
