import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final VoidCallback? onTap;
  final bool isRequestProcessing;
  const CustomTextField(
      {Key? key,
      required this.textEditingController,
      this.onTap,
      required this.isRequestProcessing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        margin: EdgeInsets.only(
            bottom: 28,
            left: constraints.maxWidth * 0.06,
            right: constraints.maxWidth * 0.06),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: 90,
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: "Open AI prompt",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      isRequestProcessing == true
                          ? Container(
                              height: 40,
                              child: Image.asset("assets/loading_response.gif"))
                          : InkWell(
                              onTap: textEditingController.text.isEmpty
                                  ? null
                                  : onTap,
                              child: Icon(
                                Feather.send,
                                color: textEditingController.text.isEmpty
                                    ? Colors.grey.withOpacity(.4)
                                    : Colors.grey,
                              ),
                            ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      );
    });
  }
}
