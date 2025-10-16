import 'package:equatable/equatable.dart';

// Abstract class for Use Cases.
// Type: The return type of the use case.
// Params: The parameters required by the use case.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// A class for use cases that do not require any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
