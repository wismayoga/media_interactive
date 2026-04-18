class Endpoints {
  static const login = "/auth/login";
  static const register = "/auth/register";

  static const dashboard = "/siswa/dashboard";

  static const materi = "/siswa/materi";
  static String materiDetail(int id) => "/siswa/materi/$id";

  static const quiz = "/siswa/quiz";
  static String quizDetail(int id) => "/siswa/quiz/$id";
  static String quizSubmit(int id) => "/siswa/quiz/$id/submit";

  static const riwayat = "/siswa/riwayat";

  static String discussionMessages(int groupId) =>
      "/discussion-groups/$groupId/messages";

  static const String me = "/auth/me";
}
