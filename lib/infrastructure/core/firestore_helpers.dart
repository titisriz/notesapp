import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_ddd/domain/auth/i_auth_facade.dart';
import 'package:notes_ddd/domain/core/errors.dart';
import 'package:notes_ddd/injection.dart';

extension FirebaseFirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOpt = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOpt.getOrElse(() => throw (NotAuthenticatedError()));
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
