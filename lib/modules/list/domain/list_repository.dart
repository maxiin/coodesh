import 'package:coodesh/failures.dart';
import 'package:dartz/dartz.dart';

class ListRepository {

  Future<Either<Failure, List<String>>> fetchWordList(int lastIndex) async {
    final List<String> items = List.generate(40, (index) => (index + lastIndex).toString()); // Initial list of items.
    return Right(items);
  }
}
