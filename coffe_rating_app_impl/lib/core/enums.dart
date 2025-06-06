enum BackendType {
  firebase,
  pocketBase,
}

extension BackendTypeExtension on BackendType {
  String get name {
    switch (this) {
      case BackendType.firebase:
        return 'Firebase';
      case BackendType.pocketBase:
        return 'PocketBase';
    }
  }
  
  String get identifier {
    switch (this) {
      case BackendType.firebase:
        return 'firebase';
      case BackendType.pocketBase:
        return 'pocketbase';
    }
  }
} 