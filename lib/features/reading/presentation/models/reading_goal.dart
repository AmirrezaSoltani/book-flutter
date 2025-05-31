class ReadingGoal {
  final String id;
  final String title;
  final String description;
  final int targetPages;
  final int currentPages;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;

  const ReadingGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetPages,
    required this.currentPages,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });

  double get progress => currentPages / targetPages;
  int get remainingPages => targetPages - currentPages;
  int get remainingDays => endDate.difference(DateTime.now()).inDays;
  bool get isOverdue => DateTime.now().isAfter(endDate) && !isCompleted;

  ReadingGoal copyWith({
    String? id,
    String? title,
    String? description,
    int? targetPages,
    int? currentPages,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
  }) {
    return ReadingGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetPages: targetPages ?? this.targetPages,
      currentPages: currentPages ?? this.currentPages,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetPages': targetPages,
      'currentPages': currentPages,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory ReadingGoal.fromJson(Map<String, dynamic> json) {
    return ReadingGoal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      targetPages: json['targetPages'],
      currentPages: json['currentPages'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'],
    );
  }
} 