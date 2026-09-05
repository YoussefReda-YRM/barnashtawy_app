abstract class DatabaseService {
  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });

  Future<dynamic> getData({
    required String path,
    String? documentId,
    List<Map<String, dynamic>>? queries,
  });

  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  });
}
