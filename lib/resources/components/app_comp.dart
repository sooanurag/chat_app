import 'package:flutter/material.dart';


class AppComponents {

  static get orDivider => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Row(
          children: [
            Expanded(
                child: Container(
              height: 1,
              color: Colors.black54,
            )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "OR",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Expanded(
                child: Container(
              height: 1,
              color: Colors.black54,
            )),
          ],
        ),
      );
}
