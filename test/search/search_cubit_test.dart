import 'package:fly_journey/src/features/search/presentation/cubit/search_cubit.dart';
import 'package:fly_journey/src/features/search/presentation/cubit/search_state.dart';
import 'package:test/test.dart';

void main() {
  group('SearchCubit', () {
    test('emits [Loading, Loaded] on success', () async {
      final cubit = SearchCubit(searchFlightsFn: (_) async {
        return {
          'success': true,
          'data': {
            'search_results': [
              {
                'flight_id': 1,
                'flight_number': 'VN123',
                'airline_name': 'Vietnam Airlines',
                'logo_url': '',
                'departure': {
                  'code': 'HAN',
                  'name': 'Noi Bai',
                  'city': 'Ha Noi',
                  'country': 'VN'
                },
                'arrival': {
                  'code': 'SGN',
                  'name': 'Tan Son Nhat',
                  'city': 'HCM',
                  'country': 'VN'
                },
                'departure_time': '2025-08-27T10:00:00Z',
                'arrival_time': '2025-08-27T12:00:00Z',
                'pricing': {'grand_total': 1000000},
                'availableSeats': 10,
                'duration_minutes': 120,
                'flight_class': 'business'
              }
            ]
          }
        };
      });

      final states = <SearchState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.search({}, false);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(states[0], isA<SearchLoading>());
      expect(states[1], isA<SearchLoaded>());
      await subscription.cancel();
      await cubit.close();
    });

    test('emits [Loading, Error] on failure', () async {
      final cubit = SearchCubit(searchFlightsFn: (_) async {
        return {'success': false, 'message': 'error'};
      });

      final states = <SearchState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.search({}, false);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(states[0], isA<SearchLoading>());
      expect(states[1], isA<SearchError>());
      await subscription.cancel();
      await cubit.close();
    });
  });
}
