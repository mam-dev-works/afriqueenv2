abstract class WellcomeEvent {}
//------------------------Event--------------------------
class ChangeLanguageEvent extends WellcomeEvent {
  ChangeLanguageEvent({required this.languageCode});
  final String languageCode;
}