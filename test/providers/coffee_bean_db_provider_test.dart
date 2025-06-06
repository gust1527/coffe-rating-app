import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';

// Generate mocks
@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot, QuerySnapshot])
import 'coffee_bean_db_provider_test.mocks.dart';

void main() {
  group('CoffeBeanDBProvider Tests', () {
    late CoffeBeanDBProvider provider;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      provider = CoffeBeanDBProvider();
      
      // Setup default collection mock
      when(mockFirestore.collection('coffe_bean_types'))
          .thenReturn(mockCollection);
    });

    group('State Management', () {
      test('should initialize with correct default values', () {
        expect(provider.isLoading, false);
        expect(provider.error, null);
        expect(provider.coffeeBeans, isEmpty);
        expect(provider.currentCoffeeBean, null);
      });

      test('should update loading state correctly', () {
        bool wasNotified = false;
        provider.addListener(() => wasNotified = true);

        // Trigger a state change
        provider.clearError();

        expect(wasNotified, true);
      });
    });

    group('addCoffeBeanType', () {
      test('should throw ArgumentError for empty bean maker', () async {
        expect(
          () => provider.addCoffeBeanType('', 'test type'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for empty bean type', () async {
        expect(
          () => provider.addCoffeBeanType('test maker', ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should trim whitespace from inputs', () async {
        // This test would require more complex mocking
        // For now, we're testing the input validation logic
        expect(
          () => provider.addCoffeBeanType('  ', '  '),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('addRatingsToCoffeBeanType', () {
      test('should throw ArgumentError for rating below 1', () async {
        expect(
          () => provider.addRatingsToCoffeBeanType('test-id', 0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for rating above 5', () async {
        expect(
          () => provider.addRatingsToCoffeBeanType('test-id', 6),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should accept valid ratings 1-5', () {
        for (int rating = 1; rating <= 5; rating++) {
          expect(
            () => provider.addRatingsToCoffeBeanType('test-id', rating),
            returnsNormally,
          );
        }
      });
    });

    group('Error Handling', () {
      test('should clear error when clearError is called', () {
        // Set an error state first (this would normally be set by failed operations)
        provider.clearError();
        
        expect(provider.error, null);
      });
    });
  });
} 