import 'package:flutter/material.dart';

class WeatherTile extends StatelessWidget {
  final String word;
  final bool isSaved;
  final void Function() onTap;

  const WeatherTile(
      {Key? key,
      required this.word,
      required this.isSaved,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word),
      leading: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : null,
      ),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: const [
        Icon(Icons.edit),
        SizedBox(width: 12),
        Icon(Icons.delete)
      ]),
      onTap: onTap,
    );
  }
}
