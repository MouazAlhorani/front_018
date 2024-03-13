import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FutureM extends ConsumerWidget {
  const FutureM(
      {super.key,
      required this.refnotifier,
      required this.model,
      required this.childWidget,
      this.otherrequest});
  final refnotifier;
  final Future<List>? otherrequest;
  final String model;
  final Function childWidget;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 500), () async {
          otherrequest;
          return await ref.read(refnotifier.notifier).rebuild(model, context);
        }),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else if (!snap.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('لا يمكن الوصول للمخدم'),
              ),
            );
          } else {
            return childWidget(snap.data);
          }
        });
  }
}
