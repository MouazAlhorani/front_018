import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/tamplates/futureM.dart';
import 'package:mouaz_app_018/tamplates/navbarM.dart';
import 'package:mouaz_app_018/tamplates/onchoosebard.dart';
import 'package:mouaz_app_018/tamplates/searchM.dart';
import 'package:mouaz_app_018/views/accounts_edit.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});
  static List localdata = [];
  // static bool sortside = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (d) {
        MmM.searchcontroller.text = '';
      },
      child: FutureM(
          refnotifier: notifierAccountsdata,
          model: 'accounts',
          childWidget: (data) {
            return MmM(basedata: data);
          }),
    );
  }
}

class MmM extends ConsumerWidget {
  const MmM({super.key, required this.basedata});
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
        'width': 200.0,
        'label': 'الاسم',
        'sortby': 'fullname',
      },
      {
        'width': 150.0,
        'label': 'الصلاحيات',
        'sortby': 'admin',
      },
      {
        'width': 150.0,
        'label': 'الحساب',
        'sortby': 'enable',
      },
    ];
    Accounts.localdata = basedata;
    Accounts.localdata = ref.watch(notifierAccountsdata);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: const Text("إدارة الحسابات"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
            leading: const Hero(
                tag: 'accounts_herotag', child: Icon(Icons.groups, size: 40)),
          ),
          body: Stack(children: [
            Accounts.localdata.isEmpty
                ? const Center(
                    child: Text("لا يوجد بيانات لعرضها"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        SearchM(
                            searchcontroller: searchcontroller,
                            refnotifier: notifierAccountsdata,
                            searchrange: const [
                              'fullname',
                              'username',
                              'admin'
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
                                          refnotifier: notifierAccountsdata),
                                      OnChooseBar(
                                        localdata: Accounts.localdata,
                                        ref: ref,
                                        refnotifier: notifierAccountsdata,
                                        searchcontroller: searchcontroller,
                                        name: 'fullname',
                                        model: 'accounts',
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: datacolumns(
                                                  ctx: context,
                                                  maincolumns: maincolumns,
                                                  ref: ref,
                                                  refnotifier:
                                                      notifierAccountsdata)))
                                    ])))
                      ]),
            NavBarMrightside(
              icon: Icons.add,
              label: "إضافة حساب جديد",
              function: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                for (var i in AccountsE.localdata.sublist(0, 6)) {
                  i['controller'].text = '';
                  i['hint'] = '';
                }
                AccountsE.localdata[6]['selected'] = 'user';
                AccountsE.localdata[7]['value'] = true;
                return const AccountsE();
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
                        pagename: 'accounts',
                        data: Accounts.localdata
                                .any((element) => element['choose'])
                            ? Accounts.localdata
                                .where((element) => element['choose'])
                                .toList()
                            : Accounts.localdata,
                        headers: [
                          'id',
                          'fullname',
                          'username',
                          'email',
                          'mobile',
                          'password',
                          'admin',
                          'enable'
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
                          'fullname',
                          'username',
                          'email',
                          'mobile',
                          'password',
                          'admin',
                          'enable'
                        ],
                        emptyroles: [1, 2, 5],
                        erroremptyrole: 'بعض الحقول لايمكن ان تكون فارغة',
                        createbulkfunction: (data) async {
                          return await StlFunction.creaebulkusers(
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
      ...Accounts.localdata.where((element) => element['search']).map((e) =>
          Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: GestureDetector(
                  onLongPress: () {
                    ref
                        .read(refnotifier.notifier)
                        .chooseitem(index: Accounts.localdata.indexOf(e));
                  },
                  onTap: () {
                    Accounts.localdata.any((element) => element['choose'])
                        ? ref
                            .read(refnotifier.notifier)
                            .chooseitem(index: Accounts.localdata.indexOf(e))
                        : Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                            AccountsE.localdata[0]['controller'].text =
                                e['fields']['fullname'] ?? '';
                            AccountsE.localdata[1]['controller'].text =
                                e['fields']['username'] ?? '';
                            AccountsE.localdata[2]['controller'].text =
                                e['fields']['email'] ?? '';
                            AccountsE.localdata[3]['controller'].text =
                                e['fields']['phone'] ?? '';
                            AccountsE.localdata[4]['controller'].text = '';
                            AccountsE.localdata[4]['hint'] = 'بدون تغيير';
                            AccountsE.localdata[5]['controller'].text = '';
                            AccountsE.localdata[5]['hint'] = 'بدون تغيير';
                            AccountsE.localdata[6]['selected'] =
                                e['fields']['admin'];
                            AccountsE.localdata[7]['value'] =
                                e['fields']['enable'];

                            return AccountsE(mainE: e);
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
                                    : e['fields']['enable']
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                Colors.transparent
                              ]),
                              border: const Border(bottom: BorderSide())),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Hero(
                                    tag: "${e['pk']}",
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.blueGrey,
                                    )),
                                ...maincolumns
                                    .sublist(0, 1)
                                    .map((m) => SizedBox(
                                          width: m['width'],
                                          child: Text("# ${e[m['sortby']]}"),
                                        )),
                                ...maincolumns.sublist(1).map((m) => SizedBox(
                                      width: m['width'],
                                      child: Text(e['fields'][m['sortby']]
                                                  .runtimeType ==
                                              bool
                                          ? e['fields'][m['sortby']]
                                              ? "فعال"
                                              : "معطل"
                                          : "${e['fields'][m['sortby']]}"),
                                    ))
                              ]))))))
    ]);
  }
}
