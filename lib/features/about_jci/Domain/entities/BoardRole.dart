class BoardRole{
  final String id;
  final String name;
  final int priority;

  BoardRole({required this.id, required this.name, required this.priority});

  static List<BoardRole> createBoardRoles() {
    return [
      BoardRole(id: '1', name: 'Priority 1', priority: 1),
      BoardRole(id: '2', name: 'Priority 2', priority: 2),
      BoardRole(id: '3', name: 'Priority 3', priority: 3),
    ];
  }
}