import 'package:flutter/material.dart';
import 'package:notex/providers/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:notex/main.dart';

class Addnotes extends StatefulWidget {
 final bool isupdate;
final  String mtitle;
 final String mdesc;
 final int msno;

  Addnotes({
    this.isupdate = false,
    this.mtitle = "",
    this.mdesc = "",
    this.msno = 0,
  });

  @override
  State<Addnotes> createState() => _AddnotesState();
}

class _AddnotesState extends State<Addnotes> {
  FocusNode titlefocus = FocusNode();

  FocusNode descfocus = FocusNode();

  var title = TextEditingController();

  var desc = TextEditingController();

  @override
  void dispose() {
    titlefocus.dispose();
    descfocus.dispose();
    title.dispose();
    desc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (widget.isupdate) {
      title.text = widget.mtitle;
      desc.text = widget.mdesc;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var a = title.text;
          var b = desc.text;
          if (a.isNotEmpty || b.isNotEmpty) {
            if (widget.isupdate) {
              context.read<DbProvider>().updatenote(a, b, widget.msno);
            } else {
              context.read<DbProvider>().addnote(a, b);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 112, 149, 167),
                content: Center(
                  child: Text(
                    'You didn’t add anything',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }
          Navigator.pop(context);

          title.clear();
          desc.clear();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 112, 149, 167),

        label: Text( 
          widget.isupdate ? "Update Note" : 'Add',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.isupdate ? "Update Note" : "Add Note",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 112, 149, 167),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: [
              TextField(
                focusNode: titlefocus,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(descfocus);
                },
                controller: title,
                minLines: 1,
                maxLines: 2,

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hint: Text('Title', style: TextStyle(fontSize: 22)),
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: descfocus,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: desc,
                  maxLines: null,
                  expands: true,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),

                  decoration: InputDecoration(
                    hint: Text('Note', style: TextStyle(fontSize: 18)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
