part of 'splash_cubit.dart';

enum SplashStatus { loading, enableRouting}

class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.loading,
  });

  final SplashStatus status;

  SplashState copyWith({
    SplashStatus? status,
  }) {
    return SplashState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}