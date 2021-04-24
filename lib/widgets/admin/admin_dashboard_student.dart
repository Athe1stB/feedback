import 'package:intl/intl.dart';

import '../../import.dart';

class AdminDashboardStudent extends StatefulWidget {
  final type;
  AdminDashboardStudent(this.type);
  @override
  _AdminDashboardStudentState createState() => _AdminDashboardStudentState();
}

class _AdminDashboardStudentState extends State<AdminDashboardStudent> {
  AdminStudentList adminStudent;
  TextEditingController _replyController = TextEditingController();

  Future<void> _view(AdminStudent item) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  item.email,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  item.subject,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  item.body,
                  maxLines: 50,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.type,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${DateFormat.yMMMd().add_jm().format(item.createdAt)}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                if (item.reply == null) ...[
                  TextField(
                    controller: _replyController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Reply',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      adminStudent.reply(
                        reply: _replyController.text,
                        id: item.id,
                      );
                      Navigator.of(ctx).pop();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
                if (item.reply != null) ...[
                  Text(
                    'Reply:',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    item.reply,
                    maxLines: 50,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${DateFormat.yMMMd().add_jm().format(item.replyCreatedAt)}',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    adminStudent = Provider.of<AdminStudentList>(context);
    var items = widget.type == Type.all
        ? adminStudent.items
        : adminStudent.items
            .where((element) =>
                element.type == widget.type.toString().split('.').last)
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (ctx, index) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            _view(items[index]);
          },
          child: Container(
            height: 155,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            items[index].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            items[index].email,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        items[index].subject,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        items[index].body,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      items[index].type,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${DateFormat.yMMMd().add_jm().format(items[index].createdAt)}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
