import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/controllers/tween_mz.dart';
import 'package:mouaz_app_018/data/basicdata.dart';
import 'package:mouaz_app_018/views/accounts.dart';
import 'package:mouaz_app_018/views/accounts_edit.dart';
import 'package:mouaz_app_018/views/dailytasksreport.dart';
import 'package:mouaz_app_018/views/dailytasksreport_edit.dart';
import 'package:mouaz_app_018/views/help.dart';
import 'package:mouaz_app_018/views/reminds.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static bool minicontrolN = false;
  static List<Map> mainitems = [], mysettings = [];
  static bool mysettingshow = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    mainitems = [
      {
        'choose': false,
        'label': 'حسابات الموظفين',
        'discript': 'إضافة وتعديل الحسابات',
        'icon': Icons.group,
        'size': 80.0,
        'permit': BasicData.userinfo![0]['fields']['admin'] == 'superadmin',
        'index': 0,
        'page': const Accounts(),
        'herotag': 'accounts_herotag'
      },
      {
        'choose': false,
        'label': 'المهمات اليومية',
        'discript':
            'قائمة بالمهام اليومية التي يجب ان يتم التحقق منها بشكل دوري',
        'icon': Icons.report,
        'size': 80.0,
        'permit': true,
        'index': 1,
        'page': const DailyTasksReports(),
        'herotag': 'dailytasksreport_herotag'
      },
      {
        'choose': false,
        'label': 'المساعدة',
        'discript': 'طريقة عمل المهام المختلفة',
        'icon': Icons.help,
        'size': 80.0,
        'permit': true,
        'index': 2,
        'page': const Help(),
        'herotag': 'help_herotag'
      },
      {
        'choose': false,
        'label': 'التذكير',
        'discript': 'تذكير مجدول ممكن ان يكون تلقائي او يحدد بشكل يدوي',
        'icon': Icons.watch_later,
        'size': 80.0,
        'permit': true,
        'index': 3,
        'page': Reminds(),
        'herotag': 'reminds_herotag'
      }
    ];
    mysettings = [
      {
        'label': 'تغيير معلومات الحساب',
        'icon': Icons.settings,
        'rotateX': 0.0,
        'action': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            AccountsE.localdata[0]['controller'].text =
                BasicData.userinfo![0]['fields']['fullname'] ?? '';
            AccountsE.localdata[1]['controller'].text =
                BasicData.userinfo![0]['fields']['username'] ?? '';
            AccountsE.localdata[2]['controller'].text =
                BasicData.userinfo![0]['fields']['email'] ?? '';
            AccountsE.localdata[3]['controller'].text =
                BasicData.userinfo![0]['fields']['phone'] ?? '';
            AccountsE.localdata[4]['controller'].text = '';
            AccountsE.localdata[4]['hint'] = 'بدون تغيير';
            AccountsE.localdata[5]['controller'].text = '';
            AccountsE.localdata[5]['hint'] = 'بدون تغيير';
            AccountsE.localdata[6]['selected'] =
                BasicData.userinfo![0]['fields']['admin'];
            AccountsE.localdata[7]['value'] =
                BasicData.userinfo![0]['fields']['enable'];
            return AccountsE(
              selfedit: true,
              mainE: BasicData.userinfo![0],
            );
          }));
        }
      },
      {
        'label': 'تسجيل الخروج',
        'icon': Icons.logout_sharp,
        'rotateX': 0.0,
        'action': () async {
          await StlFunction.logout(ctx: context);
        }
      },
    ];

    mainitems = ref.watch(notifiermainitemsHomepage);
    mysettingshow = ref.watch(notifiershowsettingsHomepage);
    mainitems[0]['permit'] =
        BasicData.userinfo![0]['fields']['admin'] == 'superadmin';
    return SafeArea(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250),
                      children: [
                        ...mainitems.where((element) {
                          return element['permit'];
                        }).map((e) => GestureDetector(
                              onTap: () async {
                                try {} catch (t) {}
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => e['page']));
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onHover: (event) {
                                  ref
                                      .read(notifiermainitemsHomepage.notifier)
                                      .onhovermainitem(
                                          index: mainitems.indexOf(e));
                                },
                                onExit: (event) {
                                  ref
                                      .read(notifiermainitemsHomepage.notifier)
                                      .onexitmainitem(
                                          index: mainitems.indexOf(e));
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Text(
                                        e['label'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TweenM(
                                              begin: 0.0,
                                              end: e['choose'] ? 43.0 : 0.0,
                                              durationinmilli: 100,
                                              type: 'rotate',
                                              child: Hero(
                                                tag: e['herotag'] ?? '',
                                                child: Icon(
                                                  e['icon'],
                                                  size:
                                                      e['choose'] ? 45.0 : 80.0,
                                                  shadows: const [
                                                    Shadow(
                                                        color: Colors.grey,
                                                        offset: Offset(2, 3))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                                visible: e['choose'],
                                                child: Expanded(
                                                  child: Text(
                                                    e['discript'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    ref.read(notifiershowsettingsHomepage.notifier).ontap();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onHover: (e) {
                      ref.read(notifiershowsettingsHomepage.notifier).onhover();
                    },
                    onExit: (e) {
                      ref.read(notifiershowsettingsHomepage.notifier).onexit();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                Visibility(
                                    visible: mysettingshow,
                                    child: TweenM(
                                      type: 'scalex',
                                      begin: 0.0,
                                      end: 1.0,
                                      durationinmilli: 300,
                                      child: Card(
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.7),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 250,
                                              child: Text(
                                                BasicData.userinfo![0]['fields']
                                                    ['fullname'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          )),
                                    )),
                                Card(
                                  elevation: mysettingshow ? 6 : 0,
                                  color: mysettingshow
                                      ? Colors.white
                                      : Colors.deepPurpleAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person,
                                      color: mysettingshow
                                          ? Colors.deepPurpleAccent
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                            visible: mysettingshow,
                            child: SizedBox(
                              width: 250,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...mysettings.map((e) => Card(
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.6),
                                          child: TextButton.icon(
                                              onPressed: e['action'],
                                              icon: Icon(e['icon']),
                                              label: Text(
                                                e['label'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              )),
                                        ))
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
