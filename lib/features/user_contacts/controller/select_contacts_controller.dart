import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/user_contacts/repositories/select_contacts_repositories.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(
    selectContactsRepositoriesProvider,
  );
  return selectContactsRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactsRepositories = ref.watch(
    selectContactsRepositoriesProvider,
  );
  return SelectContactController(
    ref: ref,
    selectContactsRepositories: selectContactsRepositories,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactsRepositories selectContactsRepositories;

  SelectContactController({
    required this.ref,
    required this.selectContactsRepositories,
  });

  void selectContact({
    required BuildContext context,
    required Contact selectedContact,
  }) {
    selectContactsRepositories.selectContact(
      selectedContact: selectedContact,
      context: context,
    );
  }
}
