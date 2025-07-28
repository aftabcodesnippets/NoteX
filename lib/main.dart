import 'package:flutter/material.dart';
import 'package:notex/data_local/dbhelper.dart';
import 'package:notex/providers/db_provider.dart';
import 'package:notex/providers/theme_provider.dart';
import 'package:notex/splashscreen.dart';
import 'package:provider/provider.dart';
import 'addnotes.dart';
import 'package:notex/drawer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => DbProvider(dbhelper: DBhelp.getinstance),
        ),
      ],
      child: NoteX(),
    ),
  );
}

class NoteX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<ThemeProvider>().gettheme()
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool issearching = false;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  List<Map<String, dynamic>> filteredNotes = [];

  void filternotes(String query) {
    final all = context.read<DbProvider>().getAllnotes();
    final result = all.where((note) {
      final title = note[DBhelp.COLUMN_TITLE].toLowerCase();
      final desc = note[DBhelp.COLUMN_DESC].toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input) || desc.contains(input);
    }).toList();
    setState(() {
      filteredNotes = result;
    });
  }

  @override
  void initState() {
    super.initState();

    context.read<DbProvider>().getinitialnotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addnotes()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 112, 149, 167),
        child: Icon(Icons.add),
      ),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: issearching 
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Notes',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  filternotes(value);
                },
              )
            : Text(
                "NoteX",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
        backgroundColor: const Color.fromARGB(255, 112, 149, 167),
        actions: [
          issearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (issearching) {
                        searchController.clear();
                        filteredNotes = [];
                      }
                      issearching = !issearching;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  icon: Icon(Icons.close, size: 30),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      issearching=true;
                    });
                  },
                  icon: Icon(Icons.search, size: 30),
                ),

          SizedBox(width: 15),
          Consumer<ThemeProvider>(
            builder: (ctx, provider, __) {
              return IconButton(
                onPressed: () {
                  provider.updatetheme(value: !provider.gettheme());
                },
                icon: Icon(
                  provider.gettheme()
                      ? Icons.wb_sunny_rounded
                      : Icons.bedtime_rounded,
                  size: 30,
                ),
              );
            },
          ),

          SizedBox(width: 20),
        ],
      ),
      drawer: MyDrawer(),
      body: Consumer<DbProvider>(
        builder: (ctx, provider, __) {
          List<Map<String, dynamic>> allnotes = provider.getAllnotes();

          List<Map<String, dynamic>> notestoshow = issearching
              ? filteredNotes
              : allnotes;

          return allnotes.isNotEmpty
              ? ListView.builder(
                  itemCount: notestoshow.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Addnotes(
                                isupdate: true,
                                mdesc: notestoshow[index][DBhelp.COLUMN_DESC],
                                mtitle: notestoshow[index][DBhelp.COLUMN_TITLE],
                                msno: notestoshow[index][DBhelp.COLUMN_SNO],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          notestoshow[index][DBhelp.COLUMN_TITLE],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      subtitle: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Addnotes(
                                isupdate: true,
                                mdesc: notestoshow[index][DBhelp.COLUMN_DESC],
                                mtitle: notestoshow[index][DBhelp.COLUMN_TITLE],
                                msno: notestoshow[index][DBhelp.COLUMN_SNO],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          notestoshow[index][DBhelp.COLUMN_DESC],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 80,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Addnotes(
                                        isupdate: true,
                                        mdesc:
                                            notestoshow[index][DBhelp
                                                .COLUMN_DESC],
                                        mtitle:
                                            notestoshow[index][DBhelp
                                                .COLUMN_TITLE],
                                        msno:
                                            notestoshow[index][DBhelp
                                                .COLUMN_SNO],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit, size: 25),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<DbProvider>().deletenote(
                                    notestoshow[index][DBhelp.COLUMN_SNO],
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No Notes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                );
        },
      ),
    );
  }
}
