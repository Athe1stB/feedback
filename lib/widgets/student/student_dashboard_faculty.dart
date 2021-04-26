import '../../import.dart';

class StudentDashboardFaculty extends StatefulWidget {
  @override
  _StudentDashboardFacultyState createState() =>
      _StudentDashboardFacultyState();
}

class _StudentDashboardFacultyState extends State<StudentDashboardFaculty> {
  @override
  Widget build(BuildContext context) {
    var _items = Provider.of<FacultyStudentList>(context).items;

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _items.length,
      itemBuilder: (ctx, index) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => DiscussionDialog(
                item: _items[index],
                from: User.student,
                to: User.faculty,
              ),
            );
          },
          child: DiscussionCard(
            item: _items[index],
            from: User.student,
            to: User.faculty,
          ),
        ),
      ),
    );
  }
}
