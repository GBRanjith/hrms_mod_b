enum Department {
  engineering,
  design,
  leadership,
  humanResources,
  finance,
  sales,
  marketing,
  itSupport;

  String get storageValue => switch (this) {
    Department.engineering => 'engineering',
    Department.design => 'design',
    Department.leadership => 'leadership',
    Department.humanResources => 'human_resources',
    Department.finance => 'finance',
    Department.sales => 'sales',
    Department.marketing => 'marketing',
    Department.itSupport => 'it_support',
  };

  String get label => switch (this) {
    Department.engineering => 'Engineering',
    Department.design => 'Design',
    Department.leadership => 'Leadership',
    Department.humanResources => 'Human Resources',
    Department.finance => 'Finance',
    Department.sales => 'Sales',
    Department.marketing => 'Marketing',
    Department.itSupport => 'IT Support',
  };

  static Department fromStorage(String? value) {
    for (final department in Department.values) {
      if (department.storageValue == value) return department;
    }
    return Department.engineering;
  }
}
