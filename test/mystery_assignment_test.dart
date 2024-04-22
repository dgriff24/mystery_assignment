import 'package:mystery_assignment/mystery_assignment.dart';
import 'package:test/test.dart';

void main() {
  group('average logic', () {
    test('zero average', () {
      expect(average(prep: 0, exam1: 0, exam2: 0, finals: 0, hw: 0), 0);
    });
    test('100 average', () {
      double result = average(prep: 1, exam1: 1, exam2: 1, finals: 1, hw: 1);
      near(result, 100);
    });
    test('50 average', () {
      double result =
          average(prep: .5, exam1: .5, exam2: .5, finals: .5, hw: .5);
      near(result, .5);
    });

    test('exam logic', () {
      final score1 = average(prep: 1, hw: 1, exam1: .65, exam2: .9, finals: 1);
      final score2 = average(prep: 1, hw: 1, exam1: .9, exam2: .65, finals: 1);
      expect(score1, score2);

      near(score1, (50 + .65 * 15 + .9 * 20) / .85);
    });

    test('category weights', () {
      near(average(prep: 1, hw: 0, exam1: 0, exam2: 0, finals: 0), 10 / .65);
      near(average(prep: 0, hw: 1, exam1: 0, exam2: 0, finals: 0), 20 / .65);
      near(average(prep: 0, hw: 0, exam1: 1, exam2: 0, finals: 0), 20 / .65);
      near(average(prep: 0, hw: 0, exam1: 0, exam2: 1, finals: 0), 20 / .65);
      near(average(prep: 0, hw: 0, exam1: 0, exam2: 0, finals: 1), 20 / .85);
      near(average(prep: 1, hw: 0, exam1: 0, exam2: 0, finals: 1), 30 / .85);
      near(average(prep: 0, hw: 1, exam1: 0, exam2: 0, finals: 1), 40 / .85);
      near(average(prep: 0, hw: 0, exam1: 1, exam2: 0, finals: 1), 40 / .85);
      near(average(prep: 0, hw: 0, exam1: 0, exam2: 1, finals: 1), 40 / .85);
    });
  });
}

void near(double a, double b, {double eps = 1e-5, bool relative = false}) {
  var bound = relative ? eps * b.abs() : eps;
  expect(a, greaterThanOrEqualTo(b - bound));
  expect(a, lessThanOrEqualTo(b + bound));
}
