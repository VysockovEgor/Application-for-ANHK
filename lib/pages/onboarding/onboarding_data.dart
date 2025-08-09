class OnboardingItem {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

final List<OnboardingItem> onboardingData = [
  const OnboardingItem(
    imagePath: 'assets/images/onboarding1.png',
    title: 'Добро пожаловать в команду АНХК',
    description:
        'Наше приложение поможет тебе адаптироваться и быстрее погрузиться в рабочий процесс.',
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding2.png',
    title: 'Безопасность прежде всего',
    description:
        'Изучите правила безопасности и охраны труда для комфортной работы.',
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding3.png',
    title: 'Будьте в курсе событий',
    description:
        'Получайте актуальные новости и уведомления о важных событиях компании.',
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding4.png',
    title: 'Начните свой путь',
    description: 'Готовы начать? Давайте приступим к работе вместе!',
  ),
];
