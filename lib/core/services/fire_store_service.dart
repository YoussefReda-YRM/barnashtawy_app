import 'package:barnasht_app/core/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService implements DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ============================================================
  // ADD DATA
  // ============================================================

  @override
Future<String> addData({
  required String path,
  required Map<String, dynamic> data,
  String? documentId,
}) async {
  final collection = firestore.collection(path);

  final String id;

  if (documentId != null && documentId.isNotEmpty) {
    id = documentId;
  } else {
    id = collection.doc().id;
  }

  final dataWithId = {
    ...data,
    'id': id,
  };

  await collection.doc(id).set(dataWithId);

  return id;
}
  // ============================================================
  // GET DATA
  // ============================================================

  @override
  Future<dynamic> getData({
    required String path,
    String? documentId,
    List<Map<String, dynamic>>? queries,
  }) async {
    // ----------------------------------------------------------
    // Get Single Document
    // ----------------------------------------------------------

    if (documentId != null) {
      final DocumentSnapshot<Map<String, dynamic>> data = await firestore
          .collection(path)
          .doc(documentId)
          .get();

      if (!data.exists) {
        return null;
      }

      return {'id': data.id, ...?data.data()};
    }

    // ----------------------------------------------------------
    // Collection Query
    // ----------------------------------------------------------

    Query<Map<String, dynamic>> query = firestore.collection(path);

    if (queries != null && queries.isNotEmpty) {
      for (final queryData in queries) {
        // ------------------------------------------------------
        // WHERE
        // ------------------------------------------------------

        if (queryData['whereField'] != null) {
          final String field = queryData['whereField'];
          final dynamic value = queryData['whereValue'];

          query = query.where(field, isEqualTo: value);
        }

        // ------------------------------------------------------
        // ORDER BY
        // ------------------------------------------------------

        if (queryData['orderBy'] != null) {
          final String orderByField = queryData['orderBy'];

          final bool descending = queryData['descending'] ?? false;

          query = query.orderBy(orderByField, descending: descending);
        }

        // ------------------------------------------------------
        // LIMIT
        // ------------------------------------------------------

        if (queryData['limit'] != null) {
          final int limit = queryData['limit'];

          query = query.limit(limit);
        }
      }
    }

    // ----------------------------------------------------------
    // Execute Query
    // ----------------------------------------------------------

    final QuerySnapshot<Map<String, dynamic>> result = await query.get();

    return result.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }

  // ============================================================
  // CHECK DATA EXISTS
  // ============================================================

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> data = await firestore
        .collection(path)
        .doc(documentId)
        .get();

    return data.exists;
  }
}
