import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchM extends ConsumerWidget {
  const SearchM(
      {super.key,
      required this.refnotifier,
      required this.searchrange,
      required this.searchcontroller});
  final refnotifier;
  final List<String> searchrange;
  final TextEditingController searchcontroller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: searchcontroller,
          decoration: const InputDecoration(hintText: 'بحث'),
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: (x) {
            ref
                .read(refnotifier.notifier)
                .search(word: x, searchrange: searchrange);
          },
        ),
      ),
    );
  }
}
