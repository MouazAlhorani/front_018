import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/tween_mz.dart';

class NavBarMrightside extends ConsumerWidget {
  const NavBarMrightside(
      {super.key,
      required this.icon,
      required this.label,
      required this.function});
  final IconData icon;
  final String label;
  final Function function;
  static bool itemanimation = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    itemanimation = ref.watch(notifierrightbuttonNav);
    return Positioned(
        bottom: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => function(),
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onHover: (t) =>
                        ref.read(notifierrightbuttonNav.notifier).onhover(),
                    onExit: (t) =>
                        ref.read(notifierrightbuttonNav.notifier).onexit(),
                    child: Row(
                      children: [
                        Card(
                          color: itemanimation
                              ? Colors.white
                              : Colors.deepPurpleAccent,
                          child: TweenM(
                              type: 'rotate',
                              begin: 0.0,
                              durationinmilli: 300,
                              end: itemanimation ? 360.0 : 0.0,
                              child: CircleAvatar(child: Icon(icon))),
                        ),
                        Visibility(
                          visible: itemanimation,
                          child: TweenM(
                              type: 'scalex',
                              begin: 0.0,
                              end: itemanimation ? 1.0 : 0.0,
                              durationinmilli: 300,
                              child: Card(
                                  color: Colors.deepPurpleAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      label,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ))),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}

class NavBarMleftside extends ConsumerWidget {
  const NavBarMleftside(
      {super.key, required this.icon, required this.settingsitem});
  final IconData icon;
  final List settingsitem;

  static bool itemanimation = false;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    itemanimation = ref.watch(notifierleftbuttonNav);
    return Visibility(
      visible: settingsitem.where((element) => element['visible']).isNotEmpty,
      child: Positioned(
          bottom: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(notifierleftbuttonNav.notifier).ontap();
                  },
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onHover: (t) =>
                          ref.read(notifierleftbuttonNav.notifier).onhover(),
                      onExit: (t) =>
                          ref.read(notifierleftbuttonNav.notifier).onexit(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: itemanimation,
                            child: TweenM(
                                type: 'translatey',
                                begin: 200.0,
                                end: itemanimation ? 0.0 : -200.0,
                                durationinmilli: 300,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...settingsitem
                                          .where(
                                              (element) => element['visible'])
                                          .map((e) => Card(
                                                child: TextButton.icon(
                                                    onPressed: e['action'],
                                                    icon: Icon(e['icon']),
                                                    label: Text(
                                                      e['label'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    )),
                                              ))
                                    ])),
                          ),
                          Card(
                            color: itemanimation
                                ? Colors.white
                                : Colors.deepPurpleAccent,
                            child: TweenM(
                                type: 'rotate',
                                begin: 0.0,
                                durationinmilli: 300,
                                end: itemanimation ? 360.0 : 0.0,
                                child: CircleAvatar(child: Icon(icon))),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
