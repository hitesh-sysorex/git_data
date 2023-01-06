import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:git_data/commits.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hitesh Public Repos')),
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<ProjectModel>>(
        builder: (context, AsyncSnapshot projectSnap) {
          // print("${projectSnap.data!.length}");
          if (projectSnap.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                ProjectModel project = projectSnap.data[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Commits(
                            repoName: project.name!,
                          ),
                        ));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(project.image!),
                  ),
                  title: Text(project.name!),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Commits(
                                repoName: project.name!,
                              ),
                            ));
                      },
                      icon: const Icon(Icons.arrow_forward_ios)),
                );
              },
            );
          } else if (projectSnap.hasError) {
            return SizedBox(
              width: double.infinity,
              // color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
              ),
            );
          } else {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            );
          }
        },
        future: getProjectDetails(),
      ),
    );
  }

  Future<List<ProjectModel>> getProjectDetails() async {
    List<ProjectModel> projectList = [];
    var response = await http
        .get(Uri.parse('https://api.github.com/users/hitesh-sysorex/repos'));
    var jsonData = jsonDecode(response.body);

    for (var u in jsonData) {
      ProjectModel data =
          ProjectModel(name: u['name'], image: u['owner']['avatar_url']);
      projectList.add(data);
    }
    print(projectList.length);
    return projectList;
  }
}

class ProjectModel {
  String? id;
  String? name;
  String? image;
  DateTime? date;
  String? lastModifiedOn;
  String? title;
  String? description;

  ProjectModel({
    this.id,
    this.name,
    this.image,
    this.date,
    this.lastModifiedOn,
    this.title,
    this.description,
  });
}
