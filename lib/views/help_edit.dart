import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';

class HelpE extends ConsumerWidget {
  const HelpE({super.key, this.mainE});
  final Map? mainE;
  static List<Map> localdata = [
    {
      'type': 'tf',
      'label': 'الاسم',
      'controller': TextEditingController(),
      'keyboard': TextInputType.name,
      'validate_role': 'empty'
    },
    {
      'type': 'tf',
      'label': 'الشرح',
      'controller': TextEditingController(),
      'keyboard': TextInputType.multiline,
      'maxlines': 5
    },
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    localdata = ref.watch(notifierHelpEdit);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            leading: mainE == null
                ? const Icon(Icons.edit)
                : Hero(tag: '${mainE!['pk']}', child: const Icon(Icons.help)),
            title: Text(mainE == null ? "إنشاء ملف جديد" : "تعديل ملف"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_forward))
            ],
          ),
          body: localdata.isEmpty
              ? const Center(
                  child: Text("لا يوجد بيانات لعرضها"),
                )
              : SingleChildScrollView(
                  child: datacolumns(
                      ref: ref, refnotifier: notifierHelpEdit, ctx: context)),
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
                          ...localdata
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
                const Divider(),
                TextButton.icon(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await StlFunction.createEdithelp(
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
                                title: const Text("هل أنت متأكد من حذف الملف؟"),
                                actions: [
                                  IconButton(
                                      onPressed: () async =>
                                          await StlFunction.delete(
                                              notifier: notifierHelpdata,
                                              ctx: ctx,
                                              ref: ref,
                                              model: 'helps',
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
