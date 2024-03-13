import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as df;
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/tamplates/futureM.dart';
import 'package:mouaz_app_018/tamplates/navbarM.dart';
import 'package:mouaz_app_018/tamplates/onchoosebard.dart';
import 'package:mouaz_app_018/tamplates/searchM.dart';
import 'package:mouaz_app_018/views/help_edit.dart';
import 'package:url_launcher/url_launcher.dart';

class Reminds extends StatelessWidget {
  const Reminds({super.key});
  static List localdata = [];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (d) {
        HelpM.searchcontroller.text = '';
      },
      child: FutureM(
          refnotifier: notifierRemindsdata,
          model: 'reminds',
          childWidget: (data) {
            return HelpM(basedata: data);
          }),
    );
  }
}

class HelpM extends ConsumerWidget {
  const HelpM({super.key, required this.basedata});
  final List basedata;
  static TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map> maincolumns = [
      {
        'width': 200.0,
        'label': 'المعرف',
        'sortby': 'pk',
      },
      {
        'width': 250.0,
        'label': 'الاسم',
        'sortby': 'remindname',
      },
      {
        'width': 250.0,
        'label': 'تاريخ التذكير',
        'sortby': 'expiredate',
      },
    ];
    Reminds.localdata = basedata;
    Reminds.localdata = ref.watch(notifierRemindsdata);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: const Text("التذكير"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
            leading: const Hero(
                tag: 'reminds_herotag',
                child: Icon(Icons.watch_later_outlined, size: 40)),
          ),
          body: Stack(children: [
            Reminds.localdata.isEmpty
                ? const Center(
                    child: Text("لا يوجد بيانات لعرضها"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        SearchM(
                            searchcontroller: searchcontroller,
                            refnotifier: notifierRemindsdata,
                            searchrange: const [
                              'remindname',
                              'reminddesc',
                              'expiredate',
                              'remindtype'
                            ]),
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
                                          refnotifier: notifierRemindsdata),
                                      OnChooseBar(
                                        localdata: Reminds.localdata,
                                        ref: ref,
                                        refnotifier: notifierRemindsdata,
                                        searchcontroller: searchcontroller,
                                        name: 'remindname',
                                        model: 'reminds',
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: datacolumns(
                                                  ctx: context,
                                                  maincolumns: maincolumns,
                                                  ref: ref,
                                                  refnotifier:
                                                      notifierRemindsdata)))
                                    ])))
                      ]),
            // NavBarMrightside(
            //   icon: Icons.add,
            //   label: "إضافة تذكير جديد",
            //   function: () =>
            //   Navigator.push(context, MaterialPageRoute(builder: (_) {
            // for (var i in HelpE.localdata) {
            //   i['controller'].text = '';
            //   i['hint'] = '';
            // }
            // return const HelpE();
            // })),
            // ),
            NavBarMleftside(
              icon: Icons.settings,
              settingsitem: [
                {
                  'visible': kIsWeb,
                  'label': 'تصدير البيانات',
                  'icon': Icons.upload,
                  'action': () async {
                    StlFunction.createExcel(
                        pagename: 'reminds',
                        data: Reminds.localdata
                                .any((element) => element['choose'])
                            ? Reminds.localdata
                                .where((element) => element['choose'])
                                .toList()
                            : Reminds.localdata,
                        headers: [
                          'id',
                          'remindname',
                          'url',
                          'remindedesc',
                          'remindtype',
                          'expiredate',
                          'remindbefor'
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
                          'remindname',
                          'url',
                          'remindedesc',
                          'remindtype',
                          'expiredate',
                          'remindbefor'
                        ],
                        createbulkfunction: (data) async {
                          return await StlFunction.createbulkreminds(
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
      ...Reminds.localdata
          .where((element) => element['search'])
          .map((e) => Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: GestureDetector(
                  onLongPress: () {
                    ref
                        .read(refnotifier.notifier)
                        .chooseitem(index: Reminds.localdata.indexOf(e));
                  },
                  onTap: () {
                    Reminds.localdata.any((element) => element['choose'])
                        ? ref
                            .read(refnotifier.notifier)
                            .chooseitem(index: Reminds.localdata.indexOf(e))
                        : null;
                  },
                  child: Container(
                      width: 800,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.transparent,
                            e['choose'] ? Colors.redAccent : Colors.greenAccent,
                            Colors.transparent
                          ]),
                          border: const Border(bottom: BorderSide())),
                      child: ExpansionTile(
                        title: Row(children: [
                          Hero(
                              tag: "${e['pk']}",
                              child: const Icon(
                                Icons.watch_later,
                                color: Colors.blueGrey,
                              )),
                          ...maincolumns.sublist(0, 1).map((m) => SizedBox(
                                width: m['width'],
                                child: Text("# ${e[m['sortby']]}"),
                              )),
                          ...maincolumns.sublist(1).map((m) => SizedBox(
                                width: m['width'],
                                child: m['sortby'] == 'expiredate'
                                    ? Text(e['fields'][m['sortby']] == null
                                        ? 'غير محدد'
                                        : df.DateFormat('yyy-MM-dd HH:mm')
                                            .format(DateTime.parse(
                                                e['fields'][m['sortby']])))
                                    : Text("${e['fields'][m['sortby']]}"),
                              ))
                        ]),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Align(
                              //   alignment: Alignment.bottomLeft,
                              //   child: IconButton(
                              //       onPressed: () {
                              //         Navigator.push(ctx,
                              //             MaterialPageRoute(builder: (_) {
                              //           HelpE.localdata[0]['controller'].text =
                              //               e['fields']['helpname'] ?? '';
                              //           HelpE.localdata[1]['controller'].text =
                              //               e['fields']['helpdesc'] ?? '';
                              //           return HelpE(mainE: e);
                              //         }));
                              //       },
                              //       icon: Icon(Icons.edit)),
                              // ),
                              Text("المدة المتبقية"),
                              Directionality(
                                  textDirection: TextDirection.ltr,
                                  child:
                                      Text(" ${e['fields']['remainingdays']}")),
                              Divider(),
                              FutureBuilder(
                                  future: Future(() async =>
                                      await StlFunction.proccesshelpcontent(
                                          content: e['fields']['reminddesc'])),
                                  builder: (_, snap) {
                                    if (snap.hasData) {
                                      List u = snap.data;
                                      return SelectableText.rich(TextSpan(
                                        children: [
                                          ...u.map((i) => i['v']
                                              ? TextSpan(
                                                  style: Theme.of(ctx)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                  text: i['t'],
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async =>
                                                            await launchUrl(
                                                                Uri.parse(
                                                                    i['t'])))
                                              : TextSpan(text: i['t'])),
                                        ],
                                      ));
                                    } else {
                                      return SizedBox();
                                    }
                                  })
                            ],
                          )
                        ],
                      )))))
    ]);
  }
}
