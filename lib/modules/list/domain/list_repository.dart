import 'package:coodesh/failures.dart';
import 'package:dartz/dartz.dart';

class ListRepository {

  Future<Either<Failure, List<String>>> fetchWordList(int lastIndex) async {
    return Right([]);
  }
}
