import 'package:coodesh/failures.dart';
import 'package:coodesh/modules/list/domain/list_repository.dart';
import 'package:dartz/dartz.dart';

class ListUseCase { 
  final ListRepository repo;

  ListUseCase(this.repo);

  Future<Either<Failure, List<String>>> call(int lastIndex){
    return repo.fetchWordList(lastIndex);
  }
}