import 'package:flutter_test/flutter_test.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';

void main() {
  group('Rating Distribution Tests', () {
    
    test('should handle no ratings case', () {
      // Create a bean with no ratings
      final bean = CoffeBeanType(
        id: 'test-1',
        beanMaker: 'Test Maker',
        beanType: 'Test Bean',
        beanRating: [], // No ratings
        isInMachine: false,
      );
      
      // Calculate distribution (simulating the method from coffee_bean_details_page.dart)
      final distribution = _calculateRatingDistribution(bean.beanRating);
      
      // All percentages should be 0
      for (final item in distribution) {
        expect(item['percentage'], equals(0.0));
        expect(item['count'], equals(0));
      }
      
      // Should have all 5 star levels
      expect(distribution.length, equals(5));
      expect(distribution.map((item) => item['stars']).toList(), equals([5, 4, 3, 2, 1]));
    });

    test('should handle single rating case', () {
      // Create a bean with one 5-star rating
      final bean = CoffeBeanType(
        id: 'test-2',
        beanMaker: 'Test Maker',
        beanType: 'Test Bean',
        beanRating: [5], // One 5-star rating
        isInMachine: false,
      );
      
      final distribution = _calculateRatingDistribution(bean.beanRating);
      
      // 5-star should be 100%, others should be 0%
      expect(distribution[0]['stars'], equals(5));
      expect(distribution[0]['percentage'], equals(100.0));
      expect(distribution[0]['count'], equals(1));
      
      for (int i = 1; i < distribution.length; i++) {
        expect(distribution[i]['percentage'], equals(0.0));
        expect(distribution[i]['count'], equals(0));
      }
    });

    test('should handle multiple ratings correctly', () {
      // Create a bean with diverse ratings: 2 fives, 1 four, 1 three, 1 one = 5 total
      final bean = CoffeBeanType(
        id: 'test-3',
        beanMaker: 'Test Maker',
        beanType: 'Test Bean',
        beanRating: [5, 5, 4, 3, 1], // 5 ratings
        isInMachine: false,
      );
      
      final distribution = _calculateRatingDistribution(bean.beanRating);
      
      // Check 5-star: 2/5 = 40%
      expect(distribution[0]['stars'], equals(5));
      expect(distribution[0]['percentage'], equals(40.0));
      expect(distribution[0]['count'], equals(2));
      
      // Check 4-star: 1/5 = 20%
      expect(distribution[1]['stars'], equals(4));
      expect(distribution[1]['percentage'], equals(20.0));
      expect(distribution[1]['count'], equals(1));
      
      // Check 3-star: 1/5 = 20%
      expect(distribution[2]['stars'], equals(3));
      expect(distribution[2]['percentage'], equals(20.0));
      expect(distribution[2]['count'], equals(1));
      
      // Check 2-star: 0/5 = 0%
      expect(distribution[3]['stars'], equals(2));
      expect(distribution[3]['percentage'], equals(0.0));
      expect(distribution[3]['count'], equals(0));
      
      // Check 1-star: 1/5 = 20%
      expect(distribution[4]['stars'], equals(1));
      expect(distribution[4]['percentage'], equals(20.0));
      expect(distribution[4]['count'], equals(1));
    });

    test('should handle invalid ratings gracefully', () {
      // Create a bean with some invalid ratings
      final bean = CoffeBeanType(
        id: 'test-4',
        beanMaker: 'Test Maker',
        beanType: 'Test Bean',
        beanRating: [5, 0, 6, 4, -1, 3], // Mixed valid and invalid ratings
        isInMachine: false,
      );
      
      final distribution = _calculateRatingDistribution(bean.beanRating);
      
      // Only valid ratings (5, 4, 3) should be counted = 3 total
      // 5-star: 1/3 = 33.33%
      expect(distribution[0]['count'], equals(1));
      expect(distribution[0]['percentage'], closeTo(33.33, 0.1));
      
      // 4-star: 1/3 = 33.33%
      expect(distribution[1]['count'], equals(1));
      expect(distribution[1]['percentage'], closeTo(33.33, 0.1));
      
      // 3-star: 1/3 = 33.33%
      expect(distribution[2]['count'], equals(1));
      expect(distribution[2]['percentage'], closeTo(33.33, 0.1));
      
      // 2-star and 1-star should be 0
      expect(distribution[3]['count'], equals(0));
      expect(distribution[4]['count'], equals(0));
    });

    test('should handle all same ratings', () {
      // Create a bean with all 3-star ratings
      final bean = CoffeBeanType(
        id: 'test-5',
        beanMaker: 'Test Maker',
        beanType: 'Test Bean',
        beanRating: [3, 3, 3, 3], // All 3-star ratings
        isInMachine: false,
      );
      
      final distribution = _calculateRatingDistribution(bean.beanRating);
      
      // 3-star should be 100%, others should be 0%
      expect(distribution[2]['stars'], equals(3));
      expect(distribution[2]['percentage'], equals(100.0));
      expect(distribution[2]['count'], equals(4));
      
      // All other star levels should be 0%
      for (int i = 0; i < distribution.length; i++) {
        if (i != 2) { // Skip the 3-star entry
          expect(distribution[i]['percentage'], equals(0.0));
          expect(distribution[i]['count'], equals(0));
        }
      }
    });
  });
}

/// Helper method that mimics the actual implementation in coffee_bean_details_page.dart
List<Map<String, dynamic>> _calculateRatingDistribution(List<int> ratings) {
  final totalRatings = ratings.length;
  
  // Initialize distribution for all star levels (5 to 1)
  final Map<int, int> ratingCounts = {
    5: 0,
    4: 0,
    3: 0,
    2: 0,
    1: 0,
  };
  
  // Handle edge case: no ratings
  if (totalRatings == 0) {
    return [5, 4, 3, 2, 1].map((stars) => {
      'stars': stars,
      'count': 0,
      'percentage': 0.0,
    }).toList();
  }
  
  // Count actual ratings
  for (final rating in ratings) {
    // Ensure rating is within valid range (1-5)
    if (rating >= 1 && rating <= 5) {
      ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
    }
  }
  
  // Calculate valid total (excluding invalid ratings)
  final validTotal = ratingCounts.values.reduce((a, b) => a + b);
  
  // Calculate percentages and create distribution list
  return [5, 4, 3, 2, 1].map((stars) {
    final count = ratingCounts[stars] ?? 0;
    final percentage = validTotal > 0 ? (count / validTotal) * 100.0 : 0.0;
    
    return {
      'stars': stars,
      'count': count,
      'percentage': percentage,
    };
  }).toList();
} 