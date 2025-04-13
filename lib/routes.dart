import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_contact/bloc/index.dart';
import 'package:my_contact/model/index.dart';
import 'package:my_contact/screen/index.dart';
import 'package:my_contact/repositories/index.dart';

import 'utils/index.dart';

Widget _wrapWithBackHandler(BuildContext context, Widget child) {
  return PopScope(
    canPop: GoRouter.of(context).canPop(),
    onPopInvokedWithResult: (didPop, result) {
      final GoRouter router = GoRouter.of(context);
      if (!didPop) {
        if (router.canPop()) {
          router.pop();
        } else {
          _showExitDialog(context);
        }
      }
    },
    child: child,
  );
}

void _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text('Exit App', style: TextStyleShared.textStyle.title),
      content: Text(
        "Are you sure you want to exit?",
        style: TextStyleShared.textStyle.bodyMedium,
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyleShared.textStyle.bodyMedium.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => SystemNavigator.pop(),
          child: Text(
            'Exit',
            style: TextStyleShared.textStyle.bodyMedium.copyWith(
              color: Colors.red,
            ),
          ),
        ),
      ],
    ),
  );
}

Page<dynamic> _buildPageWithTransition({
  required Widget child,
  TransitionType transitionType = TransitionType.fade,
}) {
  return CustomTransitionPage(
    key: ValueKey(child.runtimeType),
    child: Builder(
      builder: (context) => _wrapWithBackHandler(context, child),
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case TransitionType.slide:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case TransitionType.scale:
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
            child: child,
          );
        case TransitionType.cupertino:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
      }
    },
  );
}

final GoRouter routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return _buildPageWithTransition(
          transitionType: TransitionType.fade,
          child: RepositoryProvider(
            create: (context) => ContactRepository(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ContactBloc(
                    contactRepository: context.read<ContactRepository>(),
                  )..add(LoadContacts(page: 1)),
                ),
                BlocProvider<HelperCubit>(
                  create: (context) => HelperCubit(),
                ),
              ],
              child: MyContact(),
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'add-contact',
          pageBuilder: (context, state) {
            final extra = state.extra as Map;
            return _buildPageWithTransition(
              transitionType: TransitionType.slide,
              child: BlocProvider<ContactBloc>.value(
                value: extra['contactBloc'],
                child: Profile(
                  contact: ContactModel.initial(),
                  isEdit: false,
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: 'edit-contact',
          pageBuilder: (context, state) {
            final extra = state.extra as Map;
            return _buildPageWithTransition(
              transitionType: TransitionType.slide,
              child: BlocProvider<ContactBloc>.value(
                value: extra['contactBloc'],
                child: Profile(
                  contact: extra['contact'],
                  isEdit: true,
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: 'send-email',
          pageBuilder: (context, state) {
            final extra = state.extra as Map;
            return _buildPageWithTransition(
              transitionType: TransitionType.cupertino,
              child: BlocProvider<ContactBloc>.value(
                value: extra['contactBloc'],
                child: SendEmailPage(contact: extra['contact']),
              ),
            );
          },
        ),
      ],
    ),
  ],
);
