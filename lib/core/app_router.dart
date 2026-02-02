import 'package:go_router/go_router.dart';
import 'package:rock_route/views/home/home_view.dart';
import 'package:rock_route/views/details/detail_view.dart';
import 'package:rock_route/models/event_model.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final eventId = state.pathParameters['id'];

        final selectedEvent = dummyEvents.firstWhere(
          (element) => element.id == eventId,
          orElse: () => dummyEvents[0],
        );

        return DetailView(event: selectedEvent);
      },
    ),
  ]
);