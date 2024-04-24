import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoCard extends StatefulWidget {
  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBgColor;
  final Function onChange;
  final int index;
  const TodoCard(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.time,
      required this.check,
      required this.iconBgColor,
      required this.onChange,
      required this.index})
      : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                activeColor: Color(0xff6cf8a9),
                checkColor: Color(0xff0e3e26),
                value: widget.check,
                onChanged: (bool? value) {
                  widget.onChange(widget.index);
                },
              ),
            ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Color(0xff5e616a),
            ),
          ),
          Expanded(
              child: Container(
            height: 75,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Color(0xff2a2e3d),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 33,
                    width: 36,
                    decoration: BoxDecoration(
                        color: widget.iconBgColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      widget.iconData,
                      color: widget.iconColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
