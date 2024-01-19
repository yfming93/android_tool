import 'dart:convert';
import 'package:flutter/material.dart';

class JsonViewer extends StatefulWidget {
  final String json;

  JsonViewer({required this.json});

  @override
  _JsonViewerState createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  late dynamic _json;
  late Map<int, bool> _expansionState;

  @override
  void initState() {
    super.initState();
    _json = json.decode(widget.json);
    _expansionState = {};
  }

  Widget _buildJsonItem(dynamic item, int index) {
    if (item is Map) {
      final keys = item.keys.toList();
      return ExpansionTile(
        onExpansionChanged: (expanded) {
          _expansionState[index] = expanded;
          setState(() {});
        },
        initiallyExpanded: _expansionState[index] ?? false,
        title: Text('{'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final key in keys)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 16.0),
                title: Text('"$key": '),
                subtitle: _buildJsonItem(item[key], index + 1),
              ),
            Text('}'),
          ],
        ),
      );
    } else if (item is List) {
      final length = item.length;
      return ExpansionTile(
        onExpansionChanged: (expanded) {
          _expansionState[index] = expanded;
          setState(() {});
        },
        initiallyExpanded: _expansionState[index] ?? false,
        title: Text('[ $length ]'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < length; i++)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 16.0),
                title: Text('$i: '),
                subtitle: _buildJsonItem(item[i], index + i + 1),
              ),
            Text(']'),
          ],
        ),
      );
    } else {
      return ListTile(
        title: Text(item.toString(), style: TextStyle(fontFamily: 'monospace')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _buildJsonItem(_json, 0),
    );
  }
}
