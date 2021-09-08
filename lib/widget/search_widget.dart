import 'package:flutter/material.dart';


class SearchWidget extends StatefulWidget {
  final String? text;
  final ValueChanged<String>? onChanged;

  const SearchWidget({Key? key, this.text, this.onChanged}) : super(key: key);
  
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final searchcontroller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: Color(0xFF41444b),
                  size: 21,
                ),
              ),
              Container(
                height: 42,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  controller: searchcontroller,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF41444b),
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Colors.black45,
                      size: 20,
                    ),
                    suffixIcon: widget.text!.isNotEmpty
                        ? GestureDetector(
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                            onTap: () {
                              searchcontroller.clear();
                              widget.onChanged!('');
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          )
                        : null,
                    hintText: "ชื่อบทความ ชื่อผู้เขียน",
                    hintStyle: TextStyle(
                      color: Color(0xFF41444b).withOpacity(0.5),
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  autocorrect: false,
                  cursorColor: Color(0xFF41444b),
                  onChanged: widget.onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}