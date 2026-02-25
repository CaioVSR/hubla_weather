import 'package:equatable/equatable.dart';

/// One-shot presentation events emitted by `CitiesCubit`.
///
/// These events drive side effects in the UI (loading overlays, snackbars)
/// without polluting the persistent state.
sealed class CitiesPresentationEvent {}

/// Signals that a data refresh encountered an error but cached data is shown.
class RefreshErrorEvent extends Equatable implements CitiesPresentationEvent {
  const RefreshErrorEvent(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
