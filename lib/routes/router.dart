import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:spooky_mb/routes/utils/animated_page_route.dart';
import 'package:spooky_mb/views/home/home_view.dart';
import 'package:spooky_mb/views/page_editor/page_editor_view.dart';
import 'package:spooky_mb/views/story_details/story_details_view.dart';

final GoRouter $router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return const HomeView().getRoute(context: context, state: state);
      },
    ),
    GoRoute(
      path: '/stories/:id',
      pageBuilder: (context, state) {
        return StoryDetailsView(
          id: int.tryParse(state.pathParameters['id']!),
        ).getRoute(context: context, state: state);
      },
    ),
    GoRoute(
      path: '/stories/:id/edit',
      pageBuilder: (context, state) => PageEditorView(
        storyId: int.tryParse(state.pathParameters['id']!)!,
        initialPageIndex: int.tryParse(state.uri.queryParameters['initialPageIndex'] ?? '') ?? 0,
        quillControllers: state.extra is Map<int, QuillController> ? state.extra as Map<int, QuillController> : null,
      ).getRoute(context: context, state: state),
    ),
    GoRoute(
      path: '/stories/new',
      pageBuilder: (context, state) {
        return const PageEditorView(storyId: null).getRoute(context: context, state: state);
      },
    ),
  ],
);

extension _PageRoute on Widget {
  CustomTransitionPage getRoute({
    required BuildContext context,
    required GoRouterState state,
    Color? fillColor,
    SharedAxisTransitionType type = SharedAxisTransitionType.vertical,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          fillColor: fillColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          child: child,
        );
      },
    );
  }
}
