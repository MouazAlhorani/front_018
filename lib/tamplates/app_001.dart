// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mouaz_app_015/controllers/provider_mz.dart';
// import 'package:mouaz_app_015/controllers/stlfunction.dart';
// import 'package:mouaz_app_015/controllers/tween_mz.dart';
// import 'package:mouaz_app_015/data/basicdata.dart';
// import 'package:mouaz_app_015/views/accounts.dart';

// // class AppTamplate01 extends StatelessWidget {
// //   const AppTamplate01(
// //       {super.key,
// //       required this.getdata,
// //       required this.pagetitle,
// //       required this.pageicon,
// //       this.herotag,
// //       required this.mywidget,
// //       this.addnewitemlabel,
// //       this.additemfunction,
// //       this.searchbar = false,
// //       this.maincolums,
// //       this.searchrange,
// //       this.edittype = false,
// //       required this.mynotifier,
// //       required this.defaulttype,
// //       this.pagename,
// //       this.headers});
// //   final Future? getdata;
// //   final String pagetitle;
// //   final String? herotag, addnewitemlabel, pagename;
// //   final IconData pageicon;
// //   final Function mywidget;
// //   final additemfunction;
// //   final bool searchbar, edittype;
// //   final List<Map>? maincolums;
// //   final List<String>? searchrange, headers;
// //   final String defaulttype;

// //   final mynotifier;
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //         child: Directionality(
// //             textDirection: TextDirection.rtl,
// //             child: FutureBuilder(
// //                 future: getdata,
// //                 builder: (_, snap) {
// //                   if (snap.connectionState == ConnectionState.waiting) {
// //                     return const Scaffold(
// //                         body: Center(
// //                             child: SizedBox(
// //                                 width: 300, child: LinearProgressIndicator())));
// //                   } else if (!snap.hasData) {
// //                     return Scaffold(
// //                         appBar: AppBar(),
// //                         body:
// //                             const Center(child: Text("لا يمكن الوصول للمخدم")));
// //                   } else {
// //                     return MmM(
// //                       pagetitle: pagetitle,
// //                       pageicon: pageicon,
// //                       herotag: herotag,
// //                       mywidget: mywidget,
// //                       basedata: snap.data,
// //                       addnewitemlabel: addnewitemlabel,
// //                       additemfunction: additemfunction,
// //                       pagename: pagename,
// //                       searchbar: searchbar,
// //                       maincolumns: maincolums,
// //                       searchrange: searchrange,
// //                       edittype: edittype,
// //                       mynotifier: mynotifier,
// //                       defaulttype: defaulttype,
// //                       headers: headers,
// //                     );
// //                   }
// //                 })));
// //   }
// // }

// class MmM extends ConsumerWidget {
//   const MmM(
//       {super.key,
//       required this.pagetitle,
//       required this.pageicon,
//       this.herotag,
//       required this.basedata,
//       required this.mywidget,
//       this.addnewitemlabel,
//       this.additemfunction,
//       this.pagename,
//       this.searchbar = false,
//       this.maincolumns,
//       this.searchrange,
//       this.edittype = false,
//       required this.mynotifier,
//       required this.defaulttype,
//       this.headers,
//       this.emptyroles,
//       this.erroremptyroles,
//       this.settingsitemlist});

//   final List basedata;
//   final String pagetitle;
//   final IconData pageicon;
//   final String? herotag, addnewitemlabel, pagename;
//   final Function mywidget;
//   final bool searchbar, edittype;
//   final List<Map>? maincolumns;
//   final List<String>? searchrange;
//   final List? headers;
//   final mynotifier;
//   final additemfunction;
//   final String defaulttype;
//   final List? emptyroles;
//   final String? erroremptyroles;
//   final List? settingsitemlist;

//   static Map showaddnewitem = {
//     'rotate': 0.0,
//     'visible': false,
//   };
//   static Map showsettings = {
//     'rotate': 0.0,
//     'visible': false,
//   };
//   static bool chooseall = false;
//   static bool sortval = true;
//   static TextEditingController searchcontroller = TextEditingController();
//   static List? settingsitems = [];
//   static List localdata = [];
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     settingsitems = settingsitemlist;

//     localdata = [
//       ...basedata.map((e) => e = {...e, 'choose': false, 'search': true})
//     ];
//     localdata = ref.watch(mynotifier);
//     // showaddnewitem = ref.watch(addnewitemNoti);
//     // showsettings = ref.watch(opensettingsNoti);
//     // settingsitems = ref.watch(settingsitemNoti);

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: SafeArea(
//         child: Scaffold(
//             appBar: AppBar(
//               actions: [
//                 Navigator.canPop(context)
//                     ? IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(Icons.arrow_forward))
//                     : SizedBox()
//               ],
//               leading: herotag == null
//                   ? Icon(pageicon, size: 45)
//                   : Hero(tag: herotag!, child: Icon(pageicon, size: 45)),
//               centerTitle: true,
//               flexibleSpace: Container(
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(colors: [
//                   Colors.deepPurpleAccent.withOpacity(0.6),
//                   Colors.blueGrey,
//                   Colors.transparent,
//                 ])),
//               ),
//               title: Text(
//                 pagetitle,
//                 style: Theme.of(context)
//                     .textTheme
//                     .labelLarge!
//                     .copyWith(color: Colors.white),
//               ),
//             ),
//             body: Stack(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     localdata.isEmpty
//                         ? const Center(
//                             child: Text("لا يوجد أي بيانات لعرضها"),
//                           )
//                         : Expanded(
//                             child: Column(
//                               children: [
//                                 searchbar == true
//                                     ? Align(
//                                         alignment: Alignment.topLeft,
//                                         child: SizedBox(
//                                           width: 300,
//                                           child: TextField(
//                                             autofocus: true,
//                                             controller: searchcontroller,
//                                             onChanged: (word) => ref
//                                                 .read(mynotifier.notifier)
//                                                 .search(
//                                                     word: word,
//                                                     searchrange: searchrange),
//                                             decoration: InputDecoration(
//                                                 label: Text("بحث")),
//                                           ),
//                                         ),
//                                       )
//                                     : Row(),
//                                 Expanded(
//                                   child: SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Column(
//                                       children: [
//                                         maincolumns == null
//                                             ? SizedBox()
//                                             : Card(
//                                                 color: Colors.yellowAccent
//                                                     .withOpacity(0.6),
//                                                 child: Row(
//                                                   children: [
//                                                     ...maincolumns!
//                                                         .map((m) => SizedBox(
//                                                               width: m['width'],
//                                                               child: Row(
//                                                                 children: [
//                                                                   IconButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         ref.read(mynotifier.notifier).sort(
//                                                                             sortby:
//                                                                                 m['sortby']);
//                                                                       },
//                                                                       icon: Icon(
//                                                                           Icons
//                                                                               .sort)),
//                                                                   Expanded(
//                                                                     child: Text(
//                                                                       m['label'],
//                                                                       textAlign:
//                                                                           TextAlign
//                                                                               .center,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             )),
//                                                   ],
//                                                 ),
//                                               ),
//                                         Visibility(
//                                             visible: MmM.localdata.any(
//                                                 (element) =>
//                                                     element['choose'] == true),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 TextButton.icon(
//                                                     onPressed: () {
//                                                       ref
//                                                           .read(mynotifier
//                                                               .notifier)
//                                                           .chooseallitemsfromsearch();
//                                                       // ref
//                                                       //     .read(settingsitemNoti
//                                                       //         .notifier)
//                                                       //     .changetoselectfromall();
//                                                     },
//                                                     icon:
//                                                         Icon(Icons.select_all),
//                                                     label: Text(
//                                                       "تحديد الجميع ضمن مجال البحث",
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .bodySmall,
//                                                     )),
//                                                 TextButton.icon(
//                                                     onPressed: () {
//                                                       ref
//                                                           .read(mynotifier
//                                                               .notifier)
//                                                           .chooseallitems();
//                                                       // ref
//                                                       //     .read(settingsitemNoti
//                                                       //         .notifier)
//                                                       //     .changetoselectfromall();
//                                                     },
//                                                     icon:
//                                                         Icon(Icons.select_all),
//                                                     label: Text(
//                                                       "تحديد الجميع",
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .bodySmall,
//                                                     )),
//                                               ],
//                                             )),
//                                         Expanded(
//                                           child: SingleChildScrollView(
//                                             child: mywidget(ref),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                 )
//                               ],
//                             ),
//                           ),

//                     //
//                   ],
//                 ),
//                 edittype == true
//                     ? SizedBox()
//                     : Positioned(
//                         left: 0.0,
//                         bottom: 0.0,
//                         child: MouseRegion(
//                           onHover: (t) =>
//                               ref.read(opensettingsNoti.notifier).onheover(),
//                           onExit: (t) =>
//                               ref.read(opensettingsNoti.notifier).onexit(),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Visibility(
//                                 visible: showsettings['rotate'] == 0.0
//                                     ? false
//                                     : true,
//                                 child: Card(
//                                   color: Colors.yellowAccent.withOpacity(0.8),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ...settingsitemlist!
//                                           .where(
//                                               (element) => element['visible'])
//                                           .map((e) => TweenM(
//                                                 type: 'translatey',
//                                                 begin: 100.0,
//                                                 end: 0.0,
//                                                 durationinmilli:
//                                                     settingsitemlist!
//                                                             .indexOf(e) *
//                                                         100,
//                                                 child: TextButton.icon(
//                                                     onPressed: e['function'],
//                                                     icon: Icon(e['icon']),
//                                                     label: Text(
//                                                       e['label'],
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .bodyMedium,
//                                                     )),
//                                               ))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                   onPressed: () => ref
//                                       .read(opensettingsNoti.notifier)
//                                       .ontap(),
//                                   icon: TweenM(
//                                     type: 'rotate',
//                                     durationinmilli: 300,
//                                     begin: 0.0,
//                                     end: showsettings['rotate'],
//                                     child: CircleAvatar(
//                                         backgroundColor:
//                                             showsettings['rotate'] == 0.0
//                                                 ? Colors.deepPurpleAccent
//                                                 : Colors.transparent,
//                                         child: Icon(Icons.settings)),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                 edittype == true
//                     ? SizedBox()
//                     : Positioned(
//                         bottom: 0.0,
//                         right: 0.0,
//                         child: GestureDetector(
//                           onTap: () => additemfunction(),
//                           child: MouseRegion(
//                             cursor: SystemMouseCursors.click,
//                             // onHover: (t) =>
//                             //     ref.read(addnewitemNoti.notifier).onheover(),
//                             // onExit: (t) =>
//                             //     ref.read(addnewitemNoti.notifier).onexit(),
//                             child: TweenM(
//                                 type: 'rotate',
//                                 begin: 0.0,
//                                 durationinmilli: 250,
//                                 end: showaddnewitem['rotate'],
//                                 child: Card(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: Row(
//                                       children: [
//                                         CircleAvatar(
//                                             backgroundColor:
//                                                 showaddnewitem['rotate'] == 0
//                                                     ? Colors.deepPurpleAccent
//                                                     : Colors.white,
//                                             child: Icon(Icons.add)),
//                                         Visibility(
//                                             visible:
//                                                 showaddnewitem['rotate'] == 0
//                                                     ? false
//                                                     : true,
//                                             child: Text(addnewitemlabel!))
//                                       ],
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                         ),
//                       ),
//               ],
//             )),
//       ),
//     );
//   }
// }
