import 'package:discern/widgets/font_text.dart';
import 'package:discern/widgets/results/result_item.dart';
import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final results;
  Results({Key? key, required this.results}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  List<String> _results = [];

  @override
  void initState() { // TODO: If object detecttion, this needs change. 
    super.initState();
    this._results.add(widget.results[0]['label']);
  }

  @override
  void dispose() {
    super.dispose();
    this._results = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            montserratText('Notable Item(s)', 25.0, FontWeight.w600, color: Color(0xFF454545)),
            Container(
              padding: EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height * 0.3,
              child: Scrollbar(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    this._results.length, (index) {
                      return ResultItem(itemType: this._results[index]);
                    },
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
