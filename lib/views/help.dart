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
import 'package:mouaz_app_018/views/help_edit.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({super.key});
  static List localdata = [];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (d) {
        HelpM.searchcontroller.text = '';
      },
      child: FutureM(
          refnotifier: notifierHelpdata,
          model: 'helps',
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
        'width': 100.0,
        'label': 'المعرف',
        'sortby': 'pk',
      },
      {
        'width': 400.0,
        'label': 'الاسم',
        'sortby': 'helpname',
      }
    ];
    Help.localdata = basedata;
    Help.localdata = ref.watch(notifierHelpdata);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: const Text("ملفات المساعدة"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
            leading: const Hero(
                tag: 'help_herotag', child: Icon(Icons.help, size: 40)),
          ),
          body: Stack(children: [
            Help.localdata.isEmpty
                ? const Center(
                    child: Text("لا يوجد بيانات لعرضها"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        SearchM(
                            searchcontroller: searchcontroller,
                            refnotifier: notifierHelpdata,
                            searchrange: const ['helpname', 'helpdesc']),
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
                                          refnotifier: notifierHelpdata),
                                      OnChooseBar(
                                        localdata: Help.localdata,
                                        ref: ref,
                                        refnotifier: notifierHelpdata,
                                        searchcontroller: searchcontroller,
                                        name: 'helpname',
                                        model: 'helps',
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: datacolumns(
                                                  ctx: context,
                                                  maincolumns: maincolumns,
                                                  ref: ref,
                                                  refnotifier:
                                                      notifierHelpdata)))
                                    ])))
                      ]),
            NavBarMrightside(
              icon: Icons.add,
              label: "إضافة ملف جديد",
              function: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                for (var i in HelpE.localdata) {
                  i['controller'].text = '';
                  i['hint'] = '';
                }
                return const HelpE();
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
                        pagename: 'helps',
                        data: Help.localdata.any((element) => element['choose'])
                            ? Help.localdata
                                .where((element) => element['choose'])
                                .toList()
                            : Help.localdata,
                        headers: [
                          'id',
                          'helpname',
                          'helpdesc',
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
                          'helpname',
                          'helpdesc',
                        ],
                        createbulkfunction: (data) async {
                          return await StlFunction.creaebulkhelps(
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
    return Column(children: [
      ...Help.localdata
          .where((element) => element['search'])
          .map((e) => Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: GestureDetector(
                  onLongPress: () {
                    ref
                        .read(refnotifier.notifier)
                        .chooseitem(index: Help.localdata.indexOf(e));
                  },
                  onTap: () {
                    Help.localdata.any((element) => element['choose'])
                        ? ref
                            .read(refnotifier.notifier)
                            .chooseitem(index: Help.localdata.indexOf(e))
                        : null;
                  },
                  child: Container(
                      width: 500,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.transparent,
                            e['choose'] ? Colors.redAccent : Colors.greenAccent,
                            Colors.transparent
                          ]),
                          border: const Border(bottom: BorderSide())),
                      child: ExpansionTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                  tag: "${e['pk']}",
                                  child: const Icon(
                                    Icons.help,
                                    color: Colors.blueGrey,
                                  )),
                              ...maincolumns.sublist(0, 1).map((m) => SizedBox(
                                    width: m['width'],
                                    child: Text("# ${e[m['sortby']]}"),
                                  )),
                              ...maincolumns.sublist(1).map((m) => SizedBox(
                                    width: m['width'] - 100,
                                    child: Text(e['fields'][m['sortby']]),
                                  ))
                            ]),
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(ctx,
                                      MaterialPageRoute(builder: (_) {
                                    HelpE.localdata[0]['controller'].text =
                                        e['fields']['helpname'] ?? '';
                                    HelpE.localdata[1]['controller'].text =
                                        e['fields']['helpdesc'] ?? '';
                                    return HelpE(mainE: e);
                                  }));
                                },
                                icon: Icon(Icons.edit)),
                          ),
                          FutureBuilder(
                              future: Future(() async =>
                                  await StlFunction.proccesshelpcontent(
                                      content: e['fields']['helpdesc'])),
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
                                                      decoration: TextDecoration
                                                          .underline),
                                              text: i['t'],
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async =>
                                                    await launchUrl(
                                                        Uri.parse(i['t'])))
                                          : TextSpan(text: i['t']))
                                    ],
                                  ));
                                } else {
                                  return SizedBox();
                                }
                              })
                        ],
                      )))))
    ]);
  }
}
