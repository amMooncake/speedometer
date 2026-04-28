import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedometer_mobile/res/dimens.dart';
import 'package:speedometer_mobile/viewmodels/calculator/calculation_history_view_model.dart';
import 'package:speedometer_mobile/views/calculator/widgets/wheel_slider.dart';

enum CalculatorField { distance, time, pace }

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  int _distanceKm = 5;
  int _distanceM = 0;

  int _timeHour = 0;
  int _timeMin = 25;
  int _timeSec = 0;

  int _paceMin = 5;
  int _paceSec = 0;

  late FixedExtentScrollController _distanceKmController;
  late FixedExtentScrollController _distanceMController;

  late FixedExtentScrollController _timeHourController;
  late FixedExtentScrollController _timeMinController;
  late FixedExtentScrollController _timeSecController;

  late FixedExtentScrollController _paceMinController;
  late FixedExtentScrollController _paceSecController;

  bool _isUpdating = false;

  final List<CalculatorField> _fieldOrder = [
    CalculatorField.time,
    CalculatorField.distance,
    CalculatorField.pace,
  ];

  @override
  void initState() {
    super.initState();
    _distanceKmController = FixedExtentScrollController(initialItem: _distanceKm);
    _distanceMController = FixedExtentScrollController(initialItem: _distanceM ~/ 10);

    _timeHourController = FixedExtentScrollController(initialItem: _timeHour);
    _timeMinController = FixedExtentScrollController(initialItem: _timeMin);
    _timeSecController = FixedExtentScrollController(initialItem: _timeSec);

    _paceMinController = FixedExtentScrollController(initialItem: _paceMin);
    _paceSecController = FixedExtentScrollController(initialItem: _paceSec);
  }

  void _onFieldEdited(CalculatorField field) {
    if (_isUpdating) return;

    setState(() {
      _fieldOrder.remove(field);
      _fieldOrder.insert(0, field);
    });

    _calculate();
  }

  void _calculate() {
    _isUpdating = true;

    final outputField = _fieldOrder[2];

    double totalMeters = (_distanceKm * 1000.0) + _distanceM;
    double totalSeconds = (_timeHour * 3600.0) + (_timeMin * 60.0) + _timeSec;
    double paceSecondsPerKm = (_paceMin * 60.0) + _paceSec;

    switch (outputField) {
      case CalculatorField.pace:
        if (totalMeters > 0) {
          double calculatedPaceSeconds = (totalSeconds / totalMeters) * 1000;
          _paceMin = (calculatedPaceSeconds / 60).floor();
          _paceSec = (calculatedPaceSeconds % 60).round();

          if (_paceMinController.hasClients) {
            _paceMinController.jumpToItem(_paceMin);
          }
          if (_paceSecController.hasClients) {
            _paceSecController.jumpToItem(_paceSec);
          }
        }
        break;

      case CalculatorField.time:
        if (totalMeters > 0) {
          double calculatedTotalSeconds = (totalMeters / 1000) * paceSecondsPerKm;
          _timeHour = (calculatedTotalSeconds / 3600).floor();
          _timeMin = ((calculatedTotalSeconds % 3600) / 60).floor();
          _timeSec = (calculatedTotalSeconds % 60).round();

          if (_timeHourController.hasClients) {
            _timeHourController.jumpToItem(_timeHour);
          }
          if (_timeMinController.hasClients) {
            _timeMinController.jumpToItem(_timeMin);
          }
          if (_timeSecController.hasClients) {
            _timeSecController.jumpToItem(_timeSec);
          }
        }
        break;

      case CalculatorField.distance:
        if (paceSecondsPerKm > 0) {
          double calculatedTotalMeters = (totalSeconds / paceSecondsPerKm) * 1000;
          _distanceKm = (calculatedTotalMeters / 1000).floor();
          _distanceM = (calculatedTotalMeters % 1000).round();
          // Snap to nearest 10 for consistency with step logic if desired,
          // or just let it display. But step logic is only for picker.
          // Let's round to 10 to match picker.
          _distanceM = (_distanceM / 10).round() * 10;

          if (_distanceKmController.hasClients) {
            _distanceKmController.jumpToItem(_distanceKm);
          }
          if (_distanceMController.hasClients) {
            _distanceMController.jumpToItem(_distanceM ~/ 10);
          }
        }
        break;
    }

    _isUpdating = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: AppDimens.paddingHorizontal(4),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            AppDimens.gap(2),

            // time
            _buildSectionTitle('Czas', CalculatorField.time),
            _buildPicker('godziny', 24, _timeHourController, (val) {
              _timeHour = val;
              _onFieldEdited(CalculatorField.time);
            }),
            _buildPicker('minuty', 60, _timeMinController, (val) {
              _timeMin = val;
              _onFieldEdited(CalculatorField.time);
            }),
            _buildPicker('sekundy', 60, _timeSecController, (val) {
              _timeSec = val;
              _onFieldEdited(CalculatorField.time);
            }),

            // distance
            AppDimens.gap(2),
            _buildSectionTitle('Dystans', CalculatorField.distance),
            _buildPicker('Km', 100, _distanceKmController, (val) {
              _distanceKm = val;
              _onFieldEdited(CalculatorField.distance);
            }),
            _buildPicker('m', 1000, _distanceMController, (val) {
              _distanceM = val;
              _onFieldEdited(CalculatorField.distance);
            }),

            // pace
            AppDimens.gap(2),
            _buildSectionTitle('Tępo', CalculatorField.pace),
            _buildPicker('Minuty', 60, _paceMinController, (val) {
              _paceMin = val;
              _onFieldEdited(CalculatorField.pace);
            }),
            _buildPicker('sekundy', 60, _paceSecController, (val) {
              _paceSec = val;
              _onFieldEdited(CalculatorField.pace);
            }),
            AppDimens.gap(2),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _saveCurrentResult(context),
                    icon: const Icon(Icons.save),
                    label: const Text('Zapisz'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showHistory(context),
                    icon: const Icon(Icons.history),
                    label: const Text('Historia'),
                  ),
                ),
              ],
            ),
            AppDimens.gap(2),
            const Divider(),
            AppDimens.gap(1),
            Text(
              'Jak to działa?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            AppDimens.gap(1),
            Text(
              'Kalkulator automatycznie oblicza pole oznaczone na pomarańczowo. '
              'Gdy zmienisz dowolną wartość, system traktuje ją jako "wejściową" i aktualizuje '
              'tę, której nie dotykałeś najdłużej.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCurrentResult(BuildContext context) {
    final historyVM = context.read<CalculationHistoryViewModel>();

    double totalMeters = (_distanceKm * 1000.0) + _distanceM;
    double totalSeconds = (_timeHour * 3600.0) + (_timeMin * 60.0) + _timeSec;
    double paceSecondsPerKm = (_paceMin * 60.0) + _paceSec;

    if (totalMeters <= 0 || totalSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ustaw dystans i czas przed zapisem!')),
      );
      return;
    }

    historyVM.addResult(
      distanceMeters: totalMeters,
      timeSeconds: totalSeconds,
      paceSecondsPerKm: paceSecondsPerKm,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zapisano wynik!')),
    );
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _HistorySheet(),
    );
  }

  Widget _buildSectionTitle(String title, CalculatorField field) {
    final isOutput = _fieldOrder[2] == field;
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(color: isOutput ? Colors.orange : null),
    );
  }

  Widget _buildPicker(
    String label,
    int count,
    FixedExtentScrollController controller,
    ValueChanged<int> onChanged,
  ) {
    final bool useStep10 = count > 100;
    final int displayedCount = useStep10 ? (count / 10).ceil() : count;

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            width: 45,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                int currentIndex = 0;
                if (controller.hasClients) {
                  currentIndex = controller.selectedItem;
                } else {
                  currentIndex = controller.initialItem;
                }

                if (currentIndex < 0) currentIndex = 0;
                if (currentIndex >= displayedCount) currentIndex = displayedCount - 1;

                final value = useStep10 ? currentIndex * 10 : currentIndex;
                return Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: WheelSlider(
              scrollDirection: Axis.horizontal,
              itemCount: displayedCount,
              controller: controller,
              itemExtent: 20, // Tighter spacing for lines
              onSelectedItemChanged: (val) {
                int clampedVal = val;
                if (clampedVal < 0) clampedVal = 0;
                if (clampedVal >= displayedCount) clampedVal = displayedCount - 1;
                onChanged(useStep10 ? clampedVal * 10 : clampedVal);
              },
              itemBuilder: (context, index) {
                final isMajor = index % 5 == 0;
                return Center(
                  child: Container(
                    width: 2,
                    height: isMajor ? 24 : 14,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(isMajor ? 80 : 40),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _distanceKmController.dispose();
    _distanceMController.dispose();

    _timeHourController.dispose();
    _timeMinController.dispose();
    _timeSecController.dispose();

    _paceMinController.dispose();
    _paceSecController.dispose();

    super.dispose();
  }
}

class _HistorySheet extends StatelessWidget {
  const _HistorySheet();

  @override
  Widget build(BuildContext context) {
    final history = context.watch<CalculationHistoryViewModel>().history;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Historia wyników',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => context.read<CalculationHistoryViewModel>().clearHistory(),
                    child: const Text('Wyczyść'),
                  ),
                ],
              ),
            ),
            const Divider(),
            if (history.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Brak zapisanych wyników'),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${item.formattedDistance} @ ${item.formattedPace}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.formattedTime),
                      trailing: Text(
                        '${item.dateTime.day}.${item.dateTime.month}.${item.dateTime.year}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
