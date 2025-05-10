import 'package:flutter/material.dart';
import 'package:lissajous/app/state/app_model_provider.dart';
import 'package:lissajous/core/global_widgets/gradient_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getLocalizedString(String key, String languageCode) {
    final ruTranslations = {
      'home_title': 'Фигуры Лиссажу',
      'intro':
          'Фигуры Лиссажу - замкнутые плоские кривые, описываемые точкой, движение которой является суперпозицией двух взаимно перпендикулярных колебаний.',
      'equations_title': 'Параметрические уравнения:',
      'equations': 'x = A₁cos(ω₁t + φ₁)\n'
          'y = A₂cos(ω₂t + φ₂)',
      'properties_title': 'Свойства фигур:',
      'properties': '• Отношение частот ω₂:ω₁ - рациональное число\n'
          '• Фигура вписана в прямоугольник 2A₁×2A₂\n'
          '• Вид зависит от отношения частот и разности фаз Δφ=φ₂-φ₁',
      'equal_freq':
          'При равных частотах (ω₂:ω₁=1:1) получаются эллипсы, которые могут вырождаться в отрезки или окружности.',
      'observation':
          'Фигуры можно наблюдать на осциллографе, подавая напряжения с рациональным отношением частот.',
      'author_title': 'Об авторе',
      'author_text':
          'Жюль Антуан Лиссажу (1822-1880) - французский математик и физик, наиболее известный своими исследованиями в области колебаний и волн. В 1857 году он разработал оптический метод изучения звуковых колебаний, используя зеркала, прикреплённые к камертонам. Этот метод позволил ему визуализировать сложные колебательные движения, которые теперь носят его имя. Лиссажу преподавал математику в Лицее Сент-Луи в Париже и был членом Французского физического общества. Его работы внесли значительный вклад в понимание гармонических колебаний и их визуализации.',
    };

    final enTranslations = {
      'home_title': 'Lissajous Figures',
      'intro':
          'Lissajous figures are closed plane curves traced by a point executing two perpendicular harmonic oscillations.',
      'equations_title': 'Parametric equations:',
      'equations': 'x = A₁cos(ω₁t + φ₁)\n'
          'y = A₂cos(ω₂t + φ₂)',
      'properties_title': 'Figure properties:',
      'properties': '• Frequency ratio ω₂:ω₁ is a rational number\n'
          '• Figure is inscribed in 2A₁×2A₂ rectangle\n'
          '• Shape depends on frequency ratio and phase difference Δφ=φ₂-φ₁',
      'equal_freq':
          'With equal frequencies (ω₂:ω₁=1:1) we get ellipses that can degenerate into line segments or circles.',
      'observation':
          'The figures can be observed on an oscilloscope by applying voltages with rational frequency ratio.',
      'author_title': 'About the Author',
      'author_text':
          'Jules Antoine Lissajous (1822-1880) was a French mathematician and physicist best known for his work on vibrations and waves. In 1857, he developed an optical method for studying sound vibrations using mirrors attached to tuning forks. This method allowed him to visualize complex oscillatory motions that now bear his name. Lissajous taught mathematics at the Lycée Saint-Louis in Paris and was a member of the French Physical Society. His work made significant contributions to the understanding of harmonic oscillations and their visualization.',
    };

    return languageCode == 'ru'
        ? ruTranslations[key] ?? key
        : enTranslations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final appModel = AppModelProvider.of(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: GradientAppBar(
        title: _getLocalizedString('home_title', appModel.languageCode),
        isDarkTheme: appModel.isDarkTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lissajous figure visualization - занимает 90% ширины экрана
            Center(
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, 'assets/resize.jpg'),
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2, // Соотношение 3:2
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/resize.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.auto_awesome,
                          size: 60,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Introduction text
            Text(
              _getLocalizedString('intro', appModel.languageCode),
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Equations section
            _buildSection(
              theme,
              _getLocalizedString('equations_title', appModel.languageCode),
              _getLocalizedString('equations', appModel.languageCode),
              isCode: true,
            ),

            // Properties section
            _buildSection(
              theme,
              _getLocalizedString('properties_title', appModel.languageCode),
              _getLocalizedString('properties', appModel.languageCode),
            ),

            // Special case for equal frequencies
            Text(
              _getLocalizedString('equal_freq', appModel.languageCode),
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Observation info
            Text(
              _getLocalizedString('observation', appModel.languageCode),
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: theme.dividerColor),
            const SizedBox(height: 20),
            Text(
              _getLocalizedString('author_title', appModel.languageCode),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/lissajous.jpg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Текст об авторе
                Expanded(
                  child: Text(
                    _getLocalizedString('author_text', appModel.languageCode),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content,
      {bool isCode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: isCode
                ? theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'RobotoMono',
                    height: 1.5,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
