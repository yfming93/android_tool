import 'package:tools/widget/text_view.dart';
import 'package:flutter/material.dart';

class ResultDialog extends StatefulWidget {
  final String? title;
  final String? content;
  final bool? isSuccess;

  const ResultDialog({Key? key, this.title, this.content, this.isSuccess})
      : super(key: key);

  @override
  State<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  // Timer? _timer;
  //
  // @override
  // initState() {
  //   super.initState();
  //   Future.delayed(Duration.zero).then((value) {
  //     _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
  //       Navigator.of(context).pop();
  //     });
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextView(widget.title ?? "提示"),
      content: SelectableTextView(
        widget.isSuccess != null
            ? widget.isSuccess!
            ? "操作成功"
            : "操作失败"
            : widget.content ?? "",
      ),
      actions: <Widget>[
        TextButton(
          child: const TextView("确定"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
