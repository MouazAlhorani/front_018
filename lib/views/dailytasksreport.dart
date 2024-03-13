import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/data/basicdata.dart';
import 'package:mouaz_app_018/tamplates/futureM.dart';
import 'package:mouaz_app_018/tamplates/navbarM.dart';
import 'package:mouaz_app_018/tamplates/searchM.dart';
import 'package:mouaz_app_018/views/dailytasks.dart';
import 'package:mouaz_app_018/views/dailytasksreport_edit.dart';
import 'package:mouaz_app_018/views/help_edit.dart';
import 'package:intl/intl.dart' as df;

class DailyTasksReports extends StatelessWidget {
  const DailyTasksReports({super.key});
  static List localdata = [], userreportsshow = [];
  static DateTime reportdate = DateTime.now();
  static int x = 1;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (d) {
        DailyTasksReportsM.searchcontroller.text = '';
      },
      child: FutureM(
          otherrequest: Future(() async => userreportsshow =
              await StlFunction.getalldata(
                  ctx: context, model: 'usersreportsshow')),
          refnotifier: notifierDailyTasksReportdata,
          model: 'dailytasksreports',
          childWidget: (data) {
            return DailyTasksReportsM(
              basedata: data,
              usersrepoertsshow: userreportsshow,
            );
          }),
    );
  }
}

class DailyTasksReportsM extends ConsumerWidget {
  const DailyTasksReportsM(
      {super.key, required this.basedata, required this.usersrepoertsshow});
  final List basedata, usersrepoertsshow;
  static TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DailyTasksReports.localdata = basedata;
    DailyTasksReports.localdata = ref.watch(notifierDailyTasksReportdata);
    DailyTasksReports.reportdate =
        ref.watch(notifierDailyTasksReportdataSetDate);
    return PopScope(
      onPopInvoked: (did) {
        ref.read(notifierDailyTasksReportdataSetDate.notifier).setdefault();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: const Text("التقارير اليومية"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
            leading: const Hero(
                tag: 'dailytasksreport_herotag',
                child: Icon(Icons.report, size: 40)),
          ),
          body: Stack(children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton.icon(
                  onPressed: () async {
                    DailyTasksReports.reportdate = await ref
                        .read(notifierDailyTasksReportdataSetDate.notifier)
                        .setdate(ctx: context);
                    try {
                      await ref
                          .read(notifierDailyTasksReportdata.notifier)
                          .rebuild('dailytasksreports', context,
                              reportdate: DailyTasksReports.reportdate);
                    } catch (e) {}
                  },
                  icon: Icon(Icons.date_range),
                  label: Text(
                    df.DateFormat("yyyy-MM-dd")
                        .format(DailyTasksReports.reportdate),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ),
            DailyTasksReports.localdata.isEmpty
                ? const Center(
                    child: Text("لا يوجد بيانات لعرضها"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        SearchM(
                            searchcontroller: searchcontroller,
                            refnotifier: notifierDailyTasksReportdata,
                            searchrange: const ['report', 'createby']),
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
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: datacolumns(
                                                  ctx: context,
                                                  ref: ref,
                                                  refnotifier:
                                                      notifierDailyTasksReportdata)))
                                    ])))
                      ]),
            NavBarMrightside(
              icon: Icons.add,
              label: "إنشاء تقرير جديد",
              function: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                for (var i in HelpE.localdata) {
                  i['controller'].text = '';
                  i['hint'] = '';
                }
                return const DailyTasksReportsE();
              })),
            ),
            NavBarMleftside(
              icon: Icons.settings,
              settingsitem: [
                {
                  'visible': true,
                  'label': 'المهام اليومية',
                  'icon': Icons.task,
                  'action': () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => DailyTasks()))
                },
                {
                  'visible': kIsWeb &&
                      BasicData.userinfo![0]['fields']['admin'] == 'superadmin',
                  'label': 'تصدير البيانات',
                  'icon': Icons.upload,
                  'action': () async {
                    StlFunction.createExcel(
                        pagename: 'dailytasksreports',
                        data: await StlFunction.getalldata(
                            ctx: context,
                            model: 'dailytasksreports',
                            reportdate: 'all'),
                        headers: [
                          'id',
                          'report',
                          'reportdate',
                          'lastupdate',
                          'createby',
                        ],
                        ctx: context);
                  }
                },
                {
                  'visible': kIsWeb &&
                      BasicData.userinfo![0]['fields']['admin'] == 'superadmin',
                  'label': 'استيراد البيانات',
                  'icon': Icons.download,
                  'action': () async {
                    await StlFunction.importexcel(
                        ctx: context,
                        headers: [
                          'id',
                          'report',
                          'reportdate',
                          'lastupdate',
                          'createby',
                        ],
                        createbulkfunction: (data) async {
                          return await StlFunction.createbulktasksReports(
                              ctx: context, data: data.toString(), ref: ref);
                        });
                  }
                }
              ],
            )
          ]),
        )),
      ),
    );
  }

  datacolumns({required WidgetRef ref, refnotifier, required ctx}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        ...DailyTasksReports.localdata
            .where((element) => element['search'])
            .map((e) {
          List report = [];
          for (var i in e['fields']['report'].split('\n')) {
            report.add(i);
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MouseRegion(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                width: 500,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...report.map(
                        (e) => e.toString().contains('_comment_')
                            ? Row(
                                children: [
                                  Text(' ' * 10),
                                  Expanded(
                                    child: SelectableText(
                                        e.toString().substring(
                                            e.indexOf("_comment_") + 8),
                                        style: Theme.of(ctx)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationStyle:
                                                    TextDecorationStyle.dotted,
                                                color: Colors.brown)),
                                  ),
                                ],
                              )
                            : e.toString().contains('_maincomment_')
                                ? Row(
                                    children: [
                                      Text(' ' * 10),
                                      Expanded(
                                        child: SelectableText(
                                            e.toString().substring(
                                                e.indexOf("_comment_") + 13),
                                            style: Theme.of(ctx)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .double,
                                                    color: Colors.brown)),
                                      ),
                                    ],
                                  )
                                : e.toString().contains('_تم_') ||
                                        e.toString().contains('_تم_')
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_outlined,
                                            color: Colors.green,
                                          ),
                                          Expanded(
                                            child: SelectableText(
                                                e.toString().substring(
                                                    e.indexOf('تم') + 2),
                                                style: Theme.of(ctx)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                          ),
                                        ],
                                      )
                                    : e.toString().contains('_لا_') ||
                                            e.toString().contains('لا')
                                        ? Row(children: [
                                            Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                  e.toString().substring(
                                                      e.indexOf('لا') + 2),
                                                  style: Theme.of(ctx)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline)),
                                            ),
                                          ])
                                        : SizedBox(),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: 200,
                          child: Card(
                            color: Colors.yellowAccent.withOpacity(0.6),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(e['fields']['createby']),
                                  Text(
                                    df.DateFormat('HH:mm yyyy-MM-dd').format(
                                        DateTime.parse(
                                            e['fields']['reportdate'])),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        })
      ]),
    );
  }
}
