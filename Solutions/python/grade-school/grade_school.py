class School:
    def __init__(self):
        self._students_by_grade = {}
        self._added_status = []

    def add_student(self, name, grade):
        if grade not in self._students_by_grade:
            self._students_by_grade[grade] = []

        if name not in self.roster():
            if name not in self._students_by_grade[grade]:
                self._students_by_grade[grade].append(name)
                self._students_by_grade[grade].sort()
                self._added_status.append(True)
            else:
                self._added_status.append(False)
        else:
            self._added_status.append(False)

    def roster(self):
        all_students = []
        for grade in sorted(self._students_by_grade):
            all_students.extend(sorted(self._students_by_grade[grade]))
        return all_students

    def grade(self, grade_number):
        return sorted(self._students_by_grade.get(grade_number, []))

    def added(self):
        return self._added_status
