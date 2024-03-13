import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/tamplates/futureM.dart';
import 'package:mouaz_app_018/tamplates/navbarM.dart';
import 'package:mouaz_app_018/tamplates/onchoosebard.dart';
import 'package:mouaz_app_018/tamplates/searchM.dart';
import 'package:mouaz_app_018/views/dailytasks_edit.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyTasks extends StatelessWidget {
  const DailyTasks({super.key});
  static List localdata = [];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (d) {
        DailyTasksM.searchcontroller.text = '';
      },
      child: FutureM(
          refnotifier: notifierDailyTasksdata,
          model: 'dailytasks',
          childWidget: (data) {
            return DailyTasksM(basedata: data);
          }),
    );
  }
}

class DailyTasksM extends ConsumerWidget {
  const DailyTasksM({super.key, required this.basedata});
  final List basedata;
  static TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map> maincolumns = [
      {
        'width': 100.0,
        'label': 'المعرف',
        'sortby': 'pk',
      },
      {
        'width': 400.0,
        'label': 'المهمة',
        'sortby': 'task',
      },
    ];
    DailyTasks.localdata = basedata;
    DailyTasks.localdata = ref.watch(notifierDailyTasksdata);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: const Text("المهمات اليومية"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
            leading: const Hero(
                tag: 'dailytasks_herotag', child: Icon(Icons.task, size: 40)),
          ),
          body: Stack(children: [
            DailyTasks.localdata.isEmpty
                ? const Center(
                    child: Text("لا يوجد بيانات لعرضها"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        SearchM(
                            searchcontroller: searchcontroller,
                            refnotifier: notifierDailyTasksdata,
                            searchrange: const ['task']),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      maincolumnsrow(
                                          maincolumns: maincolumns,
                                          ref: ref,
                                          refnotifier: notifierDailyTasksdata),
                                      OnChooseBar(
                                        localdata: DailyTasks.localdata,
                                        ref: ref,
                                        refnotifier: notifierDailyTasksdata,
                                        searchcontroller: searchcontroller,
                                        name: 'task',
                                        model: 'dailytasks',
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: datacolumns(
                                                  ctx: context,
                                                  maincolumns: maincolumns,
                                                  ref: ref,
                                                  refnotifier:
                                                      notifierDailyTasksdata)))
                                    ])))
                      ]),
            NavBarMrightside(
              icon: Icons.add,
              label: "إضافة مهمة جديد",
              function: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                for (var i in DailyTasksE.localdata.sublist(0, 1)) {
                  i['controller'].text = '';
                  i['hint'] = '';
                }
                DailyTasksE.localdata[1]['selected'] = 'بدون ربط';
                return const DailyTasksE();
              })),
            ),
            NavBarMleftside(
              icon: Icons.settings,
              settingsitem: [
                {
                  'visible': kIsWeb,
                  'label': 'تصدير البيانات',
                  'icon': Icons.upload,
                  'action': () async {
                    StlFunction.createExcel(
                        pagename: 'dailytasks',
                        data: DailyTasks.localdata
                                .any((element) => element['choose'])
                            ? DailyTasks.localdata
                                .where((element) => element['choose'])
                                .toList()
                            : DailyTasks.localdata,
                        headers: [
                          'id',
                          'task',
                          'taskhelp',
                        ],
                        ctx: context);
                  }
                },
                {
                  'visible': kIsWeb,
                  'label': 'استيراد البيانات',
                  'icon': Icons.download,
                  'action': () async {
                    await StlFunction.importexcel(
                        ctx: context,
                        headers: [
                          'id',
                          'task',
                          'taskhelp',
                        ],
                        createbulkfunction: (data) async {
                          return await StlFunction.createbulktasks(
                              ctx: context, data: data.toString(), ref: ref);
                        });
                  }
                }
              ],
            )
          ]),
        )));
  }

  maincolumnsrow({maincolumns, ref, refnotifier}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...maincolumns.map((e) => Container(
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.6,
                        offset: Offset(-2, 3))
                  ],
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(5)),
                  border: Border(bottom: BorderSide(), left: BorderSide())),
              width: e['width'],
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        ref
                            .read(refnotifier.notifier)
                            .sort(sortby: e['sortby']);
                      },
                      icon: const Icon(Icons.sort_by_alpha_rounded)),
                  Text(e['label']),
                ],
              ),
            ))
      ],
    );
  }

  datacolumns({maincolumns, ref, refnotifier, required ctx}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ...DailyTasks.localdata
          .where((element) => element['search'])
          .map((e) => Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: GestureDetector(
                  onLongPress: () {
                    ref
                        .read(refnotifier.notifier)
                        .chooseitem(index: DailyTasks.localdata.indexOf(e));
                  },
                  onTap: () async {
                    String taskhelp = 'بدون ربط';
                    if (e['fields']['taskhelp'] != null) {
                      var t = await StlFunction.getsingledata(
                          model: 'helps',
                          ctx: ctx,
                          id: "${e['fields']['taskhelp']}");
                      if (t != null) {
                        taskhelp =
                            "# ${t[0]['pk']} ${t[0]['fields']['helpname']}";
                      }
                    }
                    DailyTasks.localdata.any((element) => element['choose'])
                        ? ref
                            .read(refnotifier.notifier)
                            .chooseitem(index: DailyTasks.localdata.indexOf(e))
                        : Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                            DailyTasksE.localdata[0]['controller'].text =
                                e['fields']['task'] ?? '';
                            DailyTasksE.localdata[1]['selected'] = taskhelp;

                            return DailyTasksE(mainE: e);
                          }));
                  },
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.transparent,
                                e['choose']
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                Colors.transparent
                              ]),
                              border: const Border(bottom: BorderSide())),
                          child: Row(children: [
                            Hero(
                                tag: "${e['pk']}",
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.blueGrey,
                                )),
                            ...maincolumns.sublist(0, 1).map((m) => SizedBox(
                                  width: m['width'],
                                  child: Text("# ${e[m['sortby']]}"),
                                )),
                            ...maincolumns.sublist(1).map((m) => SizedBox(
                                  width: m['width'] - 50,
                                  child: Text("${e['fields'][m['sortby']]}"),
                                )),
                            Visibility(
                              visible: e['fields']['taskhelp'] == null
                                  ? false
                                  : true,
                              child: IconButton(
                                  onPressed: () {
                                    StlFunction.showhelp(
                                        ctx: ctx,
                                        id: "${e['fields']['taskhelp']}");
                                  },
                                  icon: const Icon(Icons.help)),
                            )
                          ]))))))
    ]);
  }
}
