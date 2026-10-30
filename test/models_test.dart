import 'package:flutter_test/flutter_test.dart';
import 'package:minimalist_store/data/models/paginated_response.dart';
import 'package:minimalist_store/data/models/product_model.dart';
import 'package:minimalist_store/data/models/user_model.dart';

void main() {
  group('Model serialization', () {
    test('UserModel.fromJson parses user attributes', () {
      final user = UserModel.fromJson({
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'gender': 'female',
        'image': 'https://dummyjson.com/icon/emilys/128',
      });

      expect(user.id, 1);
      expect(user.username, 'emilys');
      expect(user.fullName, 'Emily Johnson');
    });

    test('AuthResponse.fromJson extracts accessToken and user', () {
      final auth = AuthResponse.fromJson({
        'accessToken': 'jwt_mock_token_xyz',
        'refreshToken': 'jwt_refresh_mock_abc',
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
      });

      expect(auth.accessToken, 'jwt_mock_token_xyz');
      expect(auth.refreshToken, 'jwt_refresh_mock_abc');
      expect(auth.user.username, 'emilys');
    });

    test('ProductModel.fromJson parses pricing and reviews', () {
      final product = ProductModel.fromJson({
        'id': 1,
        'title': 'Essence Mascara Lash Princess',
        'description': 'A popular mascara with dramatic lash effects.',
        'category': 'beauty',
        'price': 9.99,
        'discountPercentage': 10.0,
        'rating': 4.5,
        'stock': 15,
        'tags': ['beauty', 'mascara'],
        'brand': 'Essence',
        'reviews': [
          {
            'rating': 5,
            'comment': 'Awesome!',
            'date': '2025-01-01T00:00:00.000Z',
            'reviewerName': 'Alex',
            'reviewerEmail': 'alex@example.com',
          }
        ],
        'thumbnail': 'https://example.com/thumb.jpg',
      });

      expect(product.id, 1);
      expect(product.isInStock, true);
      expect(product.originalPrice, closeTo(11.10, 0.01));
      expect(product.reviews.first.reviewerName, 'Alex');
    });

    test('PaginatedResponse.fromDummyJson tracks hasMore', () {
      final response = PaginatedResponse.fromDummyJson(
        {
          'products': [
            {
              'id': 1,
              'title': 'Product 1',
              'price': 10.0,
              'thumbnail': 'https://example.com/1.jpg',
            },
            {
              'id': 2,
              'title': 'Product 2',
              'price': 20.0,
              'thumbnail': 'https://example.com/2.jpg',
            }
          ],
          'total': 100,
          'skip': 0,
          'limit': 2,
        },
        ProductModel.fromJson,
      );

      expect(response.items.length, 2);
      expect(response.total, 100);
      expect(response.hasMore, true);
    });
  });
}
