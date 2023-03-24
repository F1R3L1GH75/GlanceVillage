class ApiRoutes {
  static const dashboardRoutes = Dashboard();
  static const jobCardRoutes = JobCard();
  static const usersRoutes = Users();
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
}
