import '../import.dart';

class AdminFaculty {
  final int id;
  final String facultyname;
  final String facultyemail;
  final String type;
  final String subject;
  final String body;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String reply;
  final DateTime replyCreatedAt;
  final DateTime replyModifiedAt;

  AdminFaculty({
    @required this.id,
    @required this.facultyname,
    @required this.facultyemail,
    @required this.type,
    @required this.subject,
    @required this.body,
    @required this.createdAt,
    @required this.modifiedAt,
    @required this.reply,
    @required this.replyCreatedAt,
    @required this.replyModifiedAt,
  });
}

class AdminFacultyList with ChangeNotifier {
  final connection;
  AdminFacultyList(this.connection);

  List<AdminFaculty> _items = [];

  List<AdminFaculty> get items {
    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return [..._items];
  }

  Future<void> fetch({facultyid}) async {
    if (connection.isClosed) await connection.open();
    try {
      final response = facultyid == null
          ? await connection.mappedResultsQuery('''
    select *
    from admin_faculty
    left join faculty_admin using (id)
    join faculty using (facultyid)
    ''')
          : await connection.mappedResultsQuery(
              '''
    select *
    from admin_faculty
    left join faculty_admin using (id)
    join faculty using (facultyid)
    where facultyid = @facultyid
    ''',
              substitutionValues: {
                'facultyid': facultyid,
              },
            );
      final List<AdminFaculty> loadedData = [];
      if (response.isNotEmpty) {
        response.forEach((val) {
          loadedData.add(AdminFaculty(
            id: val['admin_faculty']['id'],
            facultyname: val['faculty']['name'],
            facultyemail: val['faculty']['email'],
            type: val['admin_faculty']['type'],
            subject: val['admin_faculty']['subject'],
            body: val['admin_faculty']['body'],
            createdAt: val['admin_faculty']['created_at']?.toLocal(),
            modifiedAt: val['admin_faculty']['modified_at']?.toLocal(),
            reply: val['faculty_admin']['reply'],
            replyCreatedAt: val['faculty_admin']['created_at']?.toLocal(),
            replyModifiedAt: val['faculty_admin']['modified_at']?.toLocal(),
          ));
        });
      }
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> reply({
    @required reply,
    @required id,
  }) async {
    if (connection.isClosed) await connection.open();
    final index = _items.indexWhere((element) => element.id == id);
    try {
      final response = await connection.mappedResultsQuery(
        '''
    insert into faculty_admin (id, reply)
    values (@id, @reply)
    returning *
    ''',
        substitutionValues: {
          'id': id,
          'reply': reply,
        },
      );
      if (response.isNotEmpty) {
        _items[index] = AdminFaculty(
          id: _items[index].id,
          facultyname: _items[index].facultyname,
          facultyemail: _items[index].facultyemail,
          type: _items[index].type,
          subject: _items[index].subject,
          body: _items[index].body,
          createdAt: _items[index].createdAt,
          modifiedAt: _items[index].modifiedAt,
          reply: response[0]['faculty_admin']['reply'],
          replyCreatedAt: response[0]['faculty_admin']['created_at']?.toLocal(),
          replyModifiedAt:
              response[0]['faculty_admin']['modified_at']?.toLocal(),
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> add({
    @required facultyid,
    @required type,
    @required subject,
    @required body,
  }) async {
    if (connection.isClosed) await connection.open();
    try {
      final response = await connection.mappedResultsQuery(
        '''
    with inserted as (
      insert into admin_faculty (facultyid, type, subject, body)
      values (@facultyid, @type, @subject, @body)
      returning *
    ) select *
    from inserted
    join faculty using (facultyid)
    ''',
        substitutionValues: {
          'facultyid': facultyid,
          'type': type,
          'subject': subject,
          'body': body,
        },
      );
      if (response.isNotEmpty) {
        _items.add(AdminFaculty(
          id: response[0]['admin_faculty']['id'],
          facultyname: response[0]['faculty']['name'],
          facultyemail: response[0]['faculty']['email'],
          type: response[0]['admin_faculty']['type'],
          subject: response[0]['admin_faculty']['subject'],
          body: response[0]['admin_faculty']['body'],
          createdAt: response[0]['admin_faculty']['created_at']?.toLocal(),
          modifiedAt: response[0]['admin_faculty']['modified_at']?.toLocal(),
          reply: null,
          replyCreatedAt: null,
          replyModifiedAt: null,
        ));
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  void logout() {
    _items = [];
  }
}
