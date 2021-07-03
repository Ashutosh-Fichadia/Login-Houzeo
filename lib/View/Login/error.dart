import 'package:flutter/material.dart';

import '../../size_config.dart';

class Error extends StatelessWidget {
  final List<String> errors;

  const Error({Key key, this.errors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
      List.generate(errors.length, (index) => formErrorText(error: errors[index])),

    );
  }

  Row formErrorText({String error}) {
    return Row(
      children: [
        Icon(Icons.error_outline,
          size: getProportionateScreenWidth(14),
          color: Colors.red,
        ),

        SizedBox(width: getProportionateScreenWidth(10),),
        Text(error),
      ],
    );
  }
}
