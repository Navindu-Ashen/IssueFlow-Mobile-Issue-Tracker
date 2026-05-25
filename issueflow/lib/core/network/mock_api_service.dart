import 'package:dio/dio.dart';

class MockApiService {
  final Dio _dio;

  MockApiService() : _dio = Dio() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Simulate network latency
          await Future.delayed(const Duration(milliseconds: 1500));
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  final List<Map<String, dynamic>> _mockData = [
    {
      'id': '1',
      'title': 'Fix login bug',
      'description': 'Users cannot login with valid credentials when the network is slow.',
      'status': 'Open',
      'priority': 'High',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'assignee': 'John Doe',
      'syncStatus': 'Synced',
    },
    {
      'id': '2',
      'title': 'Implement Dark Mode',
      'description': 'Add dark mode support across all screens.',
      'status': 'In Progress',
      'priority': 'Medium',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'assignee': 'Jane Smith',
      'syncStatus': 'Synced',
    },
    {
      'id': '3',
      'title': 'Update dependencies',
      'description': 'Update all packages to the latest stable versions.',
      'status': 'Resolved',
      'priority': 'Low',
      'createdAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'assignee': 'John Doe',
      'syncStatus': 'Synced',
    },
  ];

  // Simulate GET /issues
  Future<Response> getIssues() async {
    return Response(
      requestOptions: RequestOptions(path: '/issues'),
      data: List<Map<String, dynamic>>.from(_mockData),
      statusCode: 200,
    );
  }

  // Simulate POST /issues
  Future<Response> createIssue(Map<String, dynamic> data) async {
    final existingIndex = _mockData.indexWhere((issue) => issue['id'] == data['id']);
    if (existingIndex == -1) {
      _mockData.add({...data, 'syncStatus': 'Synced'});
    } else {
      _mockData[existingIndex] = {...data, 'syncStatus': 'Synced'};
    }
    return Response(
      requestOptions: RequestOptions(path: '/issues'),
      data: data,
      statusCode: 201,
    );
  }

  // Simulate PUT /issues/:id
  Future<Response> updateIssue(String id, Map<String, dynamic> data) async {
    final index = _mockData.indexWhere((issue) => issue['id'] == id);
    if (index != -1) {
      _mockData[index] = {...data, 'syncStatus': 'Synced'};
    } else {
      _mockData.add({...data, 'syncStatus': 'Synced'});
    }
    return Response(
      requestOptions: RequestOptions(path: '/issues/$id'),
      data: data,
      statusCode: 200,
    );
  }

  // Simulate DELETE /issues/:id
  Future<Response> deleteIssue(String id) async {
    _mockData.removeWhere((issue) => issue['id'] == id);
    return Response(
      requestOptions: RequestOptions(path: '/issues/$id'),
      data: {'success': true},
      statusCode: 200,
    );
  }
}
