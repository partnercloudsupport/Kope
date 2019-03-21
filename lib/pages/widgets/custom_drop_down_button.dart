import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> items;
  final String value;
  final onChanged;

  const CustomDropdownButton({Key key, this.items, this.value, this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: value,
      items: items
          .map(
            (i) => DropdownMenuItem(
          value: '${i.toString()}',
          child: Text('$i'),
        ),
      )
          .toList(),
      onChanged: (String v) {
        onChanged(v);
      },
    );
  }
}
