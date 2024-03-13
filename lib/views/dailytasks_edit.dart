import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/tamplates/futureM.dart';

class DailyTasksE extends StatelessWidget {
  const DailyTasksE({super.key, this.mainE});
  final Map? mainE;
  static List<Map> localdata = [
    {
      'type': 'tf',
      'label': 'المهمة',
      'controller': TextEditingController(),
      'keyboard': TextInputType.multiline,
      'validate_role': 'empty',
      'maxlines': 5
    },
    {'type': 'dropdown_taskhelp', 'selected': 'بدون ربط'}
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return FutureM(
        refnotifier: notifierHelpdata,
        model: 'helps',
        childWidget: (data) {
          return DailyTasksEM(
            helpfiles: data,
            mainE: mainE,
          );
        });
  }
}

class DailyTasksEM extends ConsumerWidget {
  const DailyTasksEM({super.key, required this.helpfiles, this.mainE});
  final List helpfiles;
  final Map? mainE;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DailyTasksE.localdata = ref.watch(notifierDailyTasksEdit);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            leading: mainE == null
                ? const Icon(Icons.edit)
                : Hero(tag: '${mainE!['pk']}', child: const Icon(Icons.edit)),
            title: Text(mainE == null ? "إنشاء مهمة جديدة" : "تعديل مهمة"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
          ),
          body: DailyTasksE.localdata.isEmpty
              ? const Center(
                  child: Text("لا يوجد بيانات لعرضها"),
                )
              : SingleChildScrollView(
                  child: datacolumns(
                      ref: ref,
                      refnotifier: notifierDailyTasksEdit,
                      ctx: context)),
        )));
  }

  datacolumns({required WidgetRef ref, refnotifier, required ctx}) {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Center(
      child: SizedBox(
        width: 500,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...DailyTasksE.localdata
                              .where((element) => element['type'] == 'tf')
                              .map((e) {
                            return SizedBox(
                              width: 400,
                              child: TextFormField(
                                style: Theme.of(ctx).textTheme.bodyMedium,
                                maxLines: e['maxlines'] ?? 1,
                                validator: (value) {
                                  switch (e['validate_role']) {
                                    case 'empty':
                                      if (e['controller'].text != null &&
                                          e['controller'].text.trim().isEmpty) {
                                        return "لا يمكن ان يكون الحقل فارغا";
                                      }
                                  }
                                },
                                textAlign: TextAlign.center,
                                controller: e['controller'],
                                obscureText: e['obscuretext'] ?? false,
                                keyboardType: e['keyboard'],
                                decoration: InputDecoration(
                                  label: Text(e['label']),
                                  hintText: e['hint'],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    )),
                SizedBox(
                  width: 400,
                  child: Row(
                    children: [
                      const Text("ربط بملف مساعد : "),
                      DropdownButton(
                          value: DailyTasksE.localdata[1]['selected'],
                          items: [
                            DropdownMenuItem(
                              value: 'بدون ربط',
                              child: Text(
                                'بدون ربط',
                                style: Theme.of(ctx).textTheme.bodyMedium,
                              ),
                            ),
                            ...helpfiles.map((e) => DropdownMenuItem(
                                  value:
                                      "# ${e['pk']} ${e['fields']['helpname']}",
                                  child: Text(
                                    "# ${e['pk']} ${e['fields']['helpname']}",
                                    style: Theme.of(ctx).textTheme.bodyMedium,
                                  ),
                                ))
                          ],
                          onChanged: (x) {
                            ref
                                .read(refnotifier.notifier)
                                .chooseitemdromdopdown(x: x, index: 1);
                          })
                    ],
                  ),
                ),
                const Divider(),
                TextButton.icon(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await StlFunction.createEditdailytask(
                            ctx: ctx, ref: ref, e: mainE);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("حفظ"))
              ],
            ),
            Visibility(
              visible: mainE == null ? false : true,
              child: Positioned(
                  left: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.redAccent])),
                    child: IconButton(
                      onPressed: () => showDialog(
                          context: ctx,
                          builder: (_) => AlertDialog(
                                title: const Text("هل أنت متأكد من حذف المهمة"),
                                actions: [
                                  IconButton(
                                      onPressed: () async =>
                                          await StlFunction.delete(
                                              notifier: notifierDailyTasksdata,
                                              ctx: ctx,
                                              ref: ref,
                                              model: 'dailytasks',
                                              id: "${mainE!['pk']}"),
                                      icon: const Icon(Icons.delete_forever))
                                ],
                              )),
                      icon:
                          const Icon(Icons.delete_forever, color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
