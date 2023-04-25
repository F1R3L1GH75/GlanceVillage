class ApiRoutes {
  static const dashboardRoutes = Dashboard();
  static const jobCardRoutes = JobCard();
  static const usersRoutes = Users();
  static const workRoutes = Work();
  static const attendanceRoutes = Attendance();
}

class Dashboard {
  const Dashboard();
  final String getDashboardStats = '/api/dashboard/stats';
}

class JobCard {
  const JobCard();
  String getJobCardById(String id) => '/api/job-card/get/$id';
  String getJobCardByCardNumber(String cardno) =>
      '/api/job-card/get?cardno=$cardno';
  final String getAll = '/api/job-card/get';
}

class Users {
  const Users();
  final String login = '/api/users/token';
  final String refreshToken = '/api/users/token/refresh';
  String getUserAssignedPanchayats(String id) => '/api/users/$id/panchayats';
  String getFingerprint(String id) => '/api/users/$id/finger';
}

class Work {
  const Work();
  final String getAll = '/api/work';
  String getWorkById(String id) => '/api/work/$id';
  final String getWorkOrdersByWorkId = '/api/work-order';
  final String createWorkOrder = '/api/work-order';
  final String updateWorkOrder = '/api/work-order';
  String deleteWorkOrder(String id) => '/api/work-order/$id';
  String getAllWorkOrderAttendance(String id) =>
      '/api/work-order/$id/attendance';
}

class Attendance {
  const Attendance();
  final String attendanceIn = '/api/attendance/in';
  final String attendanceOut = '/api/attendance/out';
}
