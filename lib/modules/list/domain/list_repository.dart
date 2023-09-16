import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/list/data/list_file_data_source.dart';
import 'package:dartz/dartz.dart';

class ListRepository {
  final ListFileDataSource fileDataSource;

  ListRepository(this.fileDataSource);

  int SIZE = 40;

  Future<Either<Failure, List<String>>> fetchWordList(int lastIndex) async {
    List<String> words = await fileDataSource.getLines(lastIndex, lastIndex + SIZE);
    // final List<String> items = List.generate(40, (index) => (index + lastIndex).toString()); // Initial list of items.
    return Right(words);
  }
}
