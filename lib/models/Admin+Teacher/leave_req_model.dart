class LeaveRequest {
  final String id;
  final String studentId;
  final String senderId;
  final String classId;
  final String startDate;
  final String endDate;
  final String status;
  final String reason;
  final String description;
  final String createdAt;

  LeaveRequest({
    required this.id,
    required this.studentId,
    required this.senderId,
    required this.classId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
    required this.description,
    required this.createdAt,
  });

  // Factory method to create LeaveRequest from a JSON response
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['_id'] ?? '',
      studentId: json['studentId'] ?? '',
      senderId: json['senderId'] ?? '',
      classId: json['classId'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? '',
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  // Method to convert LeaveRequest to JSON (if needed for posting data)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'senderId': senderId,
      'classId': classId,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'reason': reason,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
