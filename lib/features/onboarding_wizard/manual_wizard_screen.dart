import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../design_system/colors.dart';
import '../../design_system/model_asset.dart';
import '../../design_system/tokens.dart';
import '../../design_system/widgets/before_after_slider.dart';
import '../../design_system/widgets/status_chip.dart';
import '../../design_system/widgets/step_dots.dart';
import '../../design_system/widgets/studio_switch.dart';

class _DemoSource {
  const _DemoSource({
    required this.label,
    required this.raw,
    required this.enhanced,
    required this.model,
  });
  final String label;
  final String raw;
  final String enhanced;
  final String model;
}

const _demoSources = [
  _DemoSource(
    label: 'Silla Nórdica Roble',
    raw: 'assets/demo/silla_raw.png',
    enhanced: 'assets/demo/silla_enhanced.png',
    model: 'assets/demo/silla.glb',
  ),
  _DemoSource(
    label: 'Lámpara de Mesa Cerámica',
    raw: 'assets/demo/lampara_raw.png',
    enhanced: 'assets/demo/lampara_enhanced.png',
    model: 'assets/demo/lampara.glb',
  ),
];

/// Wizard de alta manual — 6 pasos, tal como los define el spec: los datos
/// nunca se piden después de la foto, y el switch 3D vive exactamente
/// después del paso de mejora, nunca antes.
class ManualWizardScreen extends StatefulWidget {
  const ManualWizardScreen({super.key});

  @override
  State<ManualWizardScreen> createState() => _ManualWizardScreenState();
}

class _ManualWizardScreenState extends State<ManualWizardScreen> {
  int _step = 0;
  _DemoSource? _source;
  bool _convertTo3D = false;
  bool _published = false;

  final _nameCtrl = TextEditingController(text: 'Silla Nórdica Roble');
  final _skuCtrl = TextEditingController(text: 'SLL-014');
  final _categoryCtrl = TextEditingController(text: 'Mobiliario / Sillas');
  final _priceCtrl = TextEditingController(text: '349');
  final _stockCtrl = TextEditingController(text: '18');
  final _tagsCtrl = TextEditingController(text: 'madera, comedor, nórdico');
  final _descCtrl = TextEditingController(
    text:
        'Silla de comedor en madera de roble con asiento tapizado. '
        'Estructura robusta, ideal para uso diario en espacios comerciales.',
  );

  static const _titles = [
    'Datos base',
    'Foto tal cual',
    'Mejora automática',
    'Convertir a 3D',
    'Vista previa',
    'Publicar',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _categoryCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _tagsCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _canAdvance {
    switch (_step) {
      case 1:
        return _source != null;
      default:
        return true;
    }
  }

  void _next() {
    if (_step < _titles.length - 1) {
      setState(() => _step++);
      if (_step == _titles.length - 1) _publish();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _publish() {
    Future.delayed(VDuration.settle, () {
      if (mounted) setState(() => _published = true);
    });
  }

  void _startOver() {
    setState(() {
      _step = 0;
      _source = null;
      _convertTo3D = false;
      _published = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo producto')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    VSpace.lg,
                    VSpace.md,
                    VSpace.lg,
                    0,
                  ),
                  child: StepDots(total: _titles.length, current: _step),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    VSpace.lg,
                    VSpace.sm,
                    VSpace.lg,
                    0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Paso ${_step + 1} de ${_titles.length}',
                        style: TextStyle(fontSize: 12, color: c.inkFaint),
                      ),
                      const SizedBox(width: VSpace.sm),
                      Text(
                        '— ${_titles[_step]}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: c.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(VSpace.lg),
                    child: AnimatedSwitcher(
                      duration: VDuration.standard,
                      child: KeyedSubtree(
                        key: ValueKey(_step),
                        child: _buildStep(c),
                      ),
                    ),
                  ),
                ),
                if (!_published)
                  Padding(
                    padding: const EdgeInsets.all(VSpace.lg),
                    child: Row(
                      children: [
                        if (_step > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _back,
                              child: const Text('Atrás'),
                            ),
                          ),
                        if (_step > 0) const SizedBox(width: VSpace.sm),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _canAdvance ? _next : null,
                            child: Text(
                              _step == _titles.length - 2
                                  ? 'Publicar producto'
                                  : 'Continuar',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(VColors c) {
    switch (_step) {
      case 0:
        return _DataStep(
          nameCtrl: _nameCtrl,
          skuCtrl: _skuCtrl,
          categoryCtrl: _categoryCtrl,
          priceCtrl: _priceCtrl,
          stockCtrl: _stockCtrl,
          tagsCtrl: _tagsCtrl,
          descCtrl: _descCtrl,
        );
      case 1:
        return _PhotoStep(
          selected: _source,
          onSelect: (s) => setState(() => _source = s),
        );
      case 2:
        return _EnhanceStep(source: _source!);
      case 3:
        return _ToggleStep(
          value: _convertTo3D,
          onChanged: (v) => setState(() => _convertTo3D = v),
        );
      case 4:
        return _PreviewStep(
          source: _source!,
          is3D: _convertTo3D,
          name: _nameCtrl.text,
          price: _priceCtrl.text,
        );
      default:
        return _PublishStep(published: _published, onStartOver: _startOver);
    }
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.title, required this.child, this.subtitle});
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: TextStyle(color: c.inkSoft, fontSize: 13)),
        ],
        const SizedBox(height: VSpace.lg),
        child,
      ],
    );
  }
}

class _DataStep extends StatelessWidget {
  const _DataStep({
    required this.nameCtrl,
    required this.skuCtrl,
    required this.categoryCtrl,
    required this.priceCtrl,
    required this.stockCtrl,
    required this.tagsCtrl,
    required this.descCtrl,
  });

  final TextEditingController nameCtrl;
  final TextEditingController skuCtrl;
  final TextEditingController categoryCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController stockCtrl;
  final TextEditingController tagsCtrl;
  final TextEditingController descCtrl;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Cuéntanos del producto',
      subtitle: 'Estos datos alimentan la ficha del catálogo y el ERP.',
      child: Column(
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'NOMBRE'),
          ),
          const SizedBox(height: VSpace.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: skuCtrl,
                  decoration: const InputDecoration(labelText: 'SKU'),
                ),
              ),
              const SizedBox(width: VSpace.md),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(
                    labelText: 'CATEGORÍA / SUBCATEGORÍA',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: VSpace.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'PRECIO (S/)'),
                ),
              ),
              const SizedBox(width: VSpace.md),
              Expanded(
                child: TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'STOCK'),
                ),
              ),
            ],
          ),
          const SizedBox(height: VSpace.md),
          TextField(
            controller: tagsCtrl,
            decoration: const InputDecoration(
              labelText: 'TAGS (separados por coma)',
            ),
          ),
          const SizedBox(height: VSpace.md),
          TextField(
            controller: descCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'DESCRIPCIÓN'),
          ),
        ],
      ),
    );
  }
}

class _PhotoStep extends StatelessWidget {
  const _PhotoStep({required this.selected, required this.onSelect});
  final _DemoSource? selected;
  final ValueChanged<_DemoSource> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return _StepCard(
      title: 'Sube la foto tal como la tienes',
      subtitle:
          'Sin mínimos de calidad — foto de celular, luz de tienda, '
          'fondo desordenado. Vitrina se encarga del resto.',
      child: Column(
        children: _demoSources.map((s) {
          final isSel = s == selected;
          return Padding(
            padding: const EdgeInsets.only(bottom: VSpace.md),
            child: InkWell(
              borderRadius: BorderRadius.circular(VRadius.md),
              onTap: () => onSelect(s),
              child: Container(
                padding: const EdgeInsets.all(VSpace.sm),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(VRadius.md),
                  border: Border.all(color: isSel ? c.teal : c.line, width: isSel ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(VRadius.sm),
                      child: Image.asset(
                        s.raw,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: VSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.label,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Foto de ejemplo · sin editar',
                            style: TextStyle(fontSize: 12, color: c.inkFaint),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSel
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: isSel ? c.teal : c.inkFaint,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EnhanceStep extends StatelessWidget {
  const _EnhanceStep({required this.source});
  final _DemoSource source;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: 'Mejora automática',
      subtitle:
          'Fondo, luz y nitidez corregidos por IA. Arrastra la línea '
          'para comparar — esto pasa siempre, sea 2D o 3D.',
      child: BeforeAfterSlider(
        before: Image.asset(source.raw, fit: BoxFit.cover),
        after: Container(
          color: Colors.white,
          child: Image.asset(source.enhanced, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _ToggleStep extends StatelessWidget {
  const _ToggleStep({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      title: '¿Convertir este producto a 3D?',
      subtitle:
          'Es una decisión, no un proceso técnico. Si lo dejas apagado, '
          'el producto se publica igual en 2D mejorado.',
      child: StudioSwitch(value: value, onChanged: onChanged),
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.source,
    required this.is3D,
    required this.name,
    required this.price,
  });
  final _DemoSource source;
  final bool is3D;
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return _StepCard(
      title: 'Así se verá publicado',
      subtitle: is3D
          ? 'Modelo 3D generado a partir de la imagen mejorada.'
          : 'Producto publicado en 2D mejorado.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(VRadius.md),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: is3D ? c.teal : c.line),
              ),
              child: is3D
                  ? ModelViewer(
                      key: ValueKey(source.model),
                      backgroundColor: c.surface2,
                      src: modelAssetSrc(source.model),
                      autoRotate: true,
                      cameraControls: true,
                      disableZoom: false,
                    )
                  : Container(
                      color: Colors.white,
                      child: Image.asset(source.enhanced, fit: BoxFit.contain),
                    ),
            ),
          ),
          const SizedBox(height: VSpace.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$name · S/ $price',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              StatusChip(
                status: is3D ? VProductStatus.threeD : VProductStatus.twoD,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PublishStep extends StatelessWidget {
  const _PublishStep({required this.published, required this.onStartOver});
  final bool published;
  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    final c = context.vColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VSpace.xxl),
      child: Column(
        children: [
          AnimatedScale(
            scale: published ? 1 : 0.6,
            duration: VDuration.settle,
            curve: Curves.elasticOut,
            child: AnimatedOpacity(
              opacity: published ? 1 : 0,
              duration: VDuration.standard,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: c.tealTint,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.teal, width: 1.5),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: c.tealStrong,
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: VSpace.lg),
          Text(
            published ? 'Producto publicado' : 'Publicando…',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Ya está disponible en el árbol de categorías y en el showroom.',
            style: TextStyle(color: c.inkSoft),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: VSpace.xl),
          if (published)
            OutlinedButton(
              onPressed: onStartOver,
              child: const Text('Cargar otro producto'),
            ),
        ],
      ),
    );
  }
}
