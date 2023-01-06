import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Commits extends StatefulWidget {
  Commits({super.key, required this.repoName});
  String repoName;
  @override
  State<Commits> createState() => _CommitsState();
}

class _CommitsState extends State<Commits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.repoName}'s last commit")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: projectWidget(),
      ),
    );
  }

  Widget projectWidget() {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<CommitModel>>(
        builder: (context, AsyncSnapshot projectSnap) {
          // print("${projectSnap.data!.length}");
          if (projectSnap.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                CommitModel project = projectSnap.data[index];
                return Container(
                  // height: 100,
                  constraints: const BoxConstraints(minHeight: 100),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Committed By :',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              project.title!,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Committed On :',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              project.date!,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Message :',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              project.mesasge!,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (projectSnap.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Server Error'),
                ),
              ],
            );
          } else {
            return Column(
              children: const [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ],
            );
          }
        },
        future: getProjectDetails(widget.repoName),
      ),
    );
  }

  Future<List<CommitModel>> getProjectDetails(String repoName) async {
    List<CommitModel> projectList = [];
    var response = await http.get(Uri.parse(
        'https://api.github.com/repos/hitesh-sysorex/$repoName/commits'));
    var jsonData = jsonDecode(response.body);

    for (var u in jsonData) {
      print(u['commit']['committer']['date']);
      CommitModel data = CommitModel(
          mesasge: u['commit']['message'],
          date: DateFormat.yMEd()
              .add_jms()
              .format(DateTime.parse(u['commit']['committer']['date'])),
          title: u['commit']['committer']['name']);
      projectList.add(data);
    }
    print(projectList.length);
    return projectList;
  }
}

class CommitModel {
  String? id;
  String? mesasge;
  String? image;
  String? date;
  String? lastModifiedOn;
  String? title;
  String? description;

  CommitModel({
    this.id,
    this.mesasge,
    this.image,
    this.lastModifiedOn,
    this.title,
    this.description,
    this.date,
  });
}
