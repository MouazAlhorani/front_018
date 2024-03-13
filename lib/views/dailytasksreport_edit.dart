import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/provider_mz.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/tamplates/futureM.dart';

class DailyTasksReportsE extends StatelessWidget {
  const DailyTasksReportsE({super.key, this.mainE});
  final Map? mainE;
  static List<Map> localdata = [];
  static TextEditingController maincomment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureM(
        refnotifier: notifierDailyTasksdata,
        model: 'dailytasks',
        childWidget: (data) {
          return DailyTasksReportsEM(
            dailytasks: data,
            mainE: mainE,
          );
        });
  }
}

class DailyTasksReportsEM extends ConsumerWidget {
  const DailyTasksReportsEM({super.key, required this.dailytasks, this.mainE});
  final List dailytasks;
  final Map? mainE;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DailyTasksReportsE.localdata.clear();
    if (DailyTasksReportsE.localdata.isEmpty) {
      for (var i in dailytasks) {
        DailyTasksReportsE.localdata.add({
          'task': i['fields']['task'],
          'helpid': i['fields']['taskhelp'],
          'check': false,
          'comment': false,
          'controller': TextEditingController()
        });
      }
    }
    DailyTasksReportsE.localdata = ref.watch(notifierDailyTasksReportsEdit);

    return PopScope(
      onPopInvoked: (did) {
        DailyTasksReportsE.maincomment.text = '';
      },
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
              child: Scaffold(
            appBar: AppBar(
              leading: mainE == null
                  ? const Icon(Icons.edit)
                  : Hero(tag: '${mainE!['pk']}', child: const Icon(Icons.edit)),
              title: Text(mainE == null ? "إنشاء تقرير جديد" : "تعديل تقرير"),
              actions: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_forward))
              ],
            ),
            body: DailyTasksReportsE.localdata.isEmpty
                ? const Center(
                    child: Text("لا يوجد بيانات لعرضها"),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                        child: datacolumns(
                            ref: ref,
                            refnotifier: notifierDailyTasksReportsEdit,
                            ctx: context)),
                  ),
          ))),
    );
  }

  datacolumns({required WidgetRef ref, refnotifier, required ctx}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(ctx).size.width,
        ),
        ...DailyTasksReportsE.localdata.map((e) => Container(
              width: 500,
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: e['check'],
                          onChanged: (x) {
                            ref
                                .read(notifierDailyTasksReportsEdit.notifier)
                                .checkbox(
                                    x: x,
                                    index: DailyTasksReportsE.localdata
                                        .indexOf(e));
                          }),
                      SizedBox(width: 375, child: Text(e['task'])),
                      IconButton(
                          onPressed: () {
                            ref
                                .read(notifierDailyTasksReportsEdit.notifier)
                                .addcomment(
                                    index: DailyTasksReportsE.localdata
                                        .indexOf(e));
                          },
                          icon: Icon(Icons.add_comment)),
                      Visibility(
                          visible: e['helpid'] != null,
                          child: IconButton(
                              onPressed: () async {
                                await StlFunction.showhelp(
                                    ctx: ctx, id: "${e['helpid']}");
                              },
                              icon: Icon(Icons.help)))
                    ],
                  ),
                  Visibility(
                      visible: e['comment'],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all()),
                        width: 400,
                        child: TextField(
                            controller: e['controller'],
                            style: Theme.of(ctx)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                            maxLines: 2),
                      ))
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: TextField(
              controller: DailyTasksReportsE.maincomment,
              style: Theme.of(ctx)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
              maxLines: 2,
              decoration: InputDecoration(hintText: "تعليق عام"),
            ),
          ),
        ),
        const Divider(),
        TextButton.icon(
            onPressed: () async {
              await StlFunction.createEditdailytaskreport(
                  ctx: ctx, ref: ref, e: mainE);
            },
            icon: const Icon(Icons.save),
            label: const Text("حفظ")),
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
                  icon: const Icon(Icons.delete_forever, color: Colors.white),
                ),
              )),
        )
      ],
    );
  }
}
