import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';

enum DrawingTool { pen, line, rectangle, ellipse }

class DrawingElement {
  const DrawingElement({
    required this.tool,
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  final DrawingTool tool;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tool': tool.name,
      'points': points
          .map((offset) => <String, dynamic>{
                'dx': offset.dx,
                'dy': offset.dy,
              })
          .toList(),
      'color': _encodeColor(color),
      'strokeWidth': strokeWidth,
    };
  }

  factory DrawingElement.fromJson(Map<String, dynamic> json) {
    final tool = DrawingTool.values.firstWhere(
      (value) => value.name == json['tool'],
      orElse: () => DrawingTool.pen,
    );
    final colorValue = json['color'] as int? ?? _encodeColor(Colors.black);
    final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 4.0;
    final pointsJson = json['points'] as List<dynamic>? ?? const [];
    final points = pointsJson
        .map(
          (dynamic point) => Offset(
            (point['dx'] as num).toDouble(),
            (point['dy'] as num).toDouble(),
          ),
        )
        .toList();
    return DrawingElement(
      tool: tool,
      color: _decodeColor(colorValue),
      strokeWidth: strokeWidth,
      points: points,
    );
  }

  DrawingElement copyWith({
    DrawingTool? tool,
    List<Offset>? points,
    Color? color,
    double? strokeWidth,
  }) {
    return DrawingElement(
      tool: tool ?? this.tool,
      points: points ?? this.points,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}

int _encodeColor(Color color) {
  final a = (color.a * 255.0).round() & 0xff;
  final r = (color.r * 255.0).round() & 0xff;
  final g = (color.g * 255.0).round() & 0xff;
  final b = (color.b * 255.0).round() & 0xff;
  return (a << 24) | (r << 16) | (g << 8) | b;
}

Color _decodeColor(int value) => Color(value);

class DrawingNotePage extends StatefulWidget {
  const DrawingNotePage({
    super.key,
    required this.database,
    this.note,
  });

  final AppDatabase database;
  final NoteEntry? note;

  bool get isEditing => note != null;

  @override
  State<DrawingNotePage> createState() => _DrawingNotePageState();
}

class _DrawingNotePageState extends State<DrawingNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _tagsController;

  DrawingTool _selectedTool = DrawingTool.pen;
  Color _selectedColor = Colors.blueGrey[900]!;
  double _strokeWidth = 4.0;

  final List<DrawingElement> _elements = <DrawingElement>[];
  DrawingElement? _inProgress;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _tagsController = TextEditingController(text: widget.note?.tags)
      ..addListener(_handleTagsChanged);
    if (widget.note?.drawingJson != null &&
        widget.note!.drawingJson!.trim().isNotEmpty) {
      final decoded = jsonDecode(widget.note!.drawingJson!) as List<dynamic>;
      _elements
        ..clear()
        ..addAll(
          decoded
              .whereType<Map<String, dynamic>>()
              .map(DrawingElement.fromJson),
        );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController
      ..removeListener(_handleTagsChanged)
      ..dispose();
    super.dispose();
  }

  String _normalizeTags(String source) {
    final tags = source
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    return tags.join(', ');
  }

  void _handleTagsChanged() {
    setState(() {});
  }

  Set<String> _currentTagsSet() {
    return _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toSet();
  }

  void _toggleTag(String tag) {
    final tags = _currentTagsSet();
    if (!tags.add(tag)) {
      tags.remove(tag);
    }
    final ordered = tags.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final value = ordered.join(', ');
    setState(() {
      _tagsController.text = value;
    });
  }

  void _beginStroke(Offset startPoint) {
    _inProgress = DrawingElement(
      tool: _selectedTool,
      points: <Offset>[startPoint],
      color: _selectedColor,
      strokeWidth: _strokeWidth,
    );
  }

  void _updateStroke(Offset nextPoint) {
    if (_inProgress == null) return;
    final updatedPoints = List<Offset>.from(_inProgress!.points);
    if (_inProgress!.tool == DrawingTool.pen) {
      updatedPoints.add(nextPoint);
    } else {
      if (updatedPoints.length == 1) {
        updatedPoints.add(nextPoint);
      } else {
        updatedPoints[1] = nextPoint;
      }
    }
    setState(() {
      _inProgress = _inProgress!.copyWith(points: updatedPoints);
    });
  }

  void _endStroke() {
    if (_inProgress == null) return;
    setState(() {
      _elements.add(_inProgress!);
      _inProgress = null;
    });
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    if (_elements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.notesDrawingEmptyWarning)),
      );
      return;
    }
    final drawingJson =
        jsonEncode(_elements.map((element) => element.toJson()).toList());
    final tags = _normalizeTags(_tagsController.text);
    final title = _titleController.text.trim().isEmpty
        ? loc.notesUntitled
        : _titleController.text.trim();

    setState(() {
      _isSaving = true;
    });
    try {
      if (widget.note == null) {
        await widget.database.insertNoteEntry(
          kind: NoteKind.drawing,
          title: title,
          drawingJson: drawingJson,
          tags: tags,
        );
      } else {
        final updated = widget.note!.copyWith(
          title: title,
          drawingJson: Value(drawingJson),
          content: const Value.absent(),
          tags: tags,
        );
        await widget.database.updateNoteEntry(updated);
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    if (widget.note == null) {
      return;
    }
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.notesDeleteDialogTitle),
        content: Text(loc.notesDeleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.genericCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.notesDeleteDialogConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await widget.database.deleteNoteEntry(widget.note!.id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _undo() {
    if (_elements.isEmpty) {
      return;
    }
    setState(() {
      _elements.removeLast();
    });
  }

  void _clearCanvas() {
    setState(() {
      _elements.clear();
      _inProgress = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final bool isCompactLayout =
        mediaQuery.size.height < 600 || mediaQuery.size.width < 600;
    final double toolbarHeight =
        isCompactLayout ? 48.0 : kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        titleTextStyle:
            isCompactLayout ? theme.textTheme.titleMedium : null,
        titleSpacing: isCompactLayout ? 8 : null,
        title: Text(
          widget.isEditing
              ? loc.notesDrawingTitleEdit
              : loc.notesDrawingTitleNew,
        ),
        actions: [
          if (widget.isEditing)
            IconButton(
              tooltip: loc.notesDeleteTooltip,
              onPressed: _isSaving ? null : _delete,
              icon: const Icon(Icons.delete),
            ),
          IconButton(
            tooltip: loc.notesDrawingUndo,
            onPressed: _elements.isEmpty ? null : _undo,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            tooltip: loc.notesDrawingClear,
            onPressed: _elements.isEmpty ? null : _clearCanvas,
            icon: const Icon(Icons.layers_clear),
          ),
          IconButton(
            tooltip: loc.notesEditorSave,
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: loc.notesTitleLabel,
                    hintText: loc.notesDrawingTitleHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: loc.notesTagLabel,
                    hintText: loc.notesTagHint,
                  ),
                ),
                const SizedBox(height: 8),
                StreamBuilder<List<String>>(
                  stream: widget.database.watchAllNoteTags(),
                  builder: (context, snapshot) {
                    final tags = snapshot.data ?? const <String>[];
                    if (tags.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final selected = _currentTagsSet();
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '${loc.notesTagSuggestionsLabel}:',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          ...tags.map(
                            (tag) => FilterChip(
                              label: Text(tag),
                              selected: selected.contains(tag),
                              onSelected: (_) => _toggleTag(tag),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          _buildToolbar(loc),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanStart: (details) => _beginStroke(details.localPosition),
                  onPanUpdate: (details) => _updateStroke(details.localPosition),
                  onPanEnd: (_) => _endStroke(),
                  child: ColoredBox(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: CustomPaint(
                      painter: _DrawingPainter(
                        elements: _elements,
                        inProgress: _inProgress,
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
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

  Widget _buildToolbar(AppLocalizations loc) {
    final colorOptions = <Color>[
      Colors.blueGrey[900]!,
      Colors.indigo,
      Colors.deepOrange,
      Colors.teal,
      Colors.pinkAccent,
      Colors.black,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SegmentedButton<DrawingTool>(
            segments: [
              ButtonSegment(
                value: DrawingTool.pen,
                label: Text(loc.notesDrawingToolPen),
                icon: const Icon(Icons.gesture),
              ),
              ButtonSegment(
                value: DrawingTool.line,
                label: Text(loc.notesDrawingToolLine),
                icon: const Icon(Icons.show_chart),
              ),
              ButtonSegment(
                value: DrawingTool.rectangle,
                label: Text(loc.notesDrawingToolRectangle),
                icon: const Icon(Icons.crop_square),
              ),
              ButtonSegment(
                value: DrawingTool.ellipse,
                label: Text(loc.notesDrawingToolEllipse),
                icon: const Icon(Icons.circle_outlined),
              ),
            ],
            selected: <DrawingTool>{_selectedTool},
            onSelectionChanged: (selection) {
              setState(() {
                _selectedTool = selection.first;
              });
            },
          ),
          const SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(loc.notesDrawingStrokeLabel),
              Slider(
                value: _strokeWidth,
                min: 1.0,
                max: 12.0,
                divisions: 11,
                label: _strokeWidth.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _strokeWidth = value;
                  });
                },
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: colorOptions
                .map(
                  (color) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: color,
                      child: _selectedColor == color
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  _DrawingPainter({
    required this.elements,
    required this.inProgress,
  });

  final List<DrawingElement> elements;
  final DrawingElement? inProgress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final element in elements) {
      _paintElement(canvas, element);
    }
    if (inProgress != null) {
      _paintElement(canvas, inProgress!);
    }
  }

  void _paintElement(Canvas canvas, DrawingElement element) {
    final paint = Paint()
      ..color = element.color
      ..strokeWidth = element.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (element.tool) {
      case DrawingTool.pen:
        final points = element.points;
        if (points.isEmpty) return;
        if (points.length == 1) {
          final dotPaint = Paint()
            ..color = element.color
            ..style = PaintingStyle.fill;
          canvas.drawCircle(points.first, element.strokeWidth / 2, dotPaint);
          return;
        }
        final path = Path()..moveTo(points.first.dx, points.first.dy);
        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, paint);
        return;
      case DrawingTool.line:
        if (element.points.length < 2) return;
        canvas.drawLine(element.points.first, element.points.last, paint);
        return;
      case DrawingTool.rectangle:
        if (element.points.length < 2) return;
        final rect = Rect.fromPoints(
          element.points.first,
          element.points.last,
        );
        canvas.drawRect(rect, paint);
        return;
      case DrawingTool.ellipse:
        if (element.points.length < 2) return;
        final rect = Rect.fromPoints(
          element.points.first,
          element.points.last,
        );
        canvas.drawOval(rect, paint);
        return;
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return true;
  }
}
