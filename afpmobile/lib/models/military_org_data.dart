class MilitaryOrgData {
  final List<Branch> branches;

  MilitaryOrgData({required this.branches});

  factory MilitaryOrgData.fromJson(Map<String, dynamic> json) {
    return MilitaryOrgData(
      branches:
          (json['branches'] as List)
              .map((branch) => Branch.fromJson(branch))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'branches': branches.map((branch) => branch.toJson()).toList()};
  }
}

class Branch {
  final String id;
  final String name;
  final String code;
  final List<Division> divisions;
  final List<Rank> ranks;

  Branch({
    required this.id,
    required this.name,
    required this.code,
    required this.divisions,
    required this.ranks,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      divisions:
          (json['divisions'] as List? ?? [])
              .map((division) => Division.fromJson(division))
              .toList(),
      ranks:
          (json['ranks'] as List? ?? [])
              .map((rank) => Rank.fromJson(rank))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'divisions': divisions.map((division) => division.toJson()).toList(),
      'ranks': ranks.map((rank) => rank.toJson()).toList(),
    };
  }

  @override
  String toString() => name;
}

class Division {
  final String id;
  final String name;
  final String code;
  final List<Unit> units;

  Division({
    required this.id,
    required this.name,
    required this.code,
    required this.units,
  });

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      units:
          (json['units'] as List? ?? [])
              .map((unit) => Unit.fromJson(unit))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'units': units.map((unit) => unit.toJson()).toList(),
    };
  }

  @override
  String toString() => name;
}

class Unit {
  final String id;
  final String name;
  final String code;

  Unit({required this.id, required this.name, required this.code});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }

  @override
  String toString() => name;
}

class Rank {
  final String id;
  final String name;
  final String code;
  final int order;

  Rank({
    required this.id,
    required this.name,
    required this.code,
    required this.order,
  });

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'order': order};
  }

  @override
  String toString() => name;
}

