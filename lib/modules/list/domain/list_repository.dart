import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/list/data/list_file_data_source.dart';
import 'package:dartz/dartz.dart';

class ListRepository {
  final ListFileDataSource fileDataSource;

  ListRepository(this.fileDataSource);

  final int size = 40;

  Future<Either<Failure, List<String>>> fetchWordList(int lastIndex) async {
    List<String> words = await fileDataSource.getLines(lastIndex, lastIndex + size);
    return Right(words);
  }
}
