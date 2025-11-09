import 'package:flutter/material.dart';

class ProfessorOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const ProfessorOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  State<ProfessorOptionCard> createState() => _ProfessorOptionCardState();
}

class _ProfessorOptionCardState extends State<ProfessorOptionCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _hovering
                    ? widget.color.withOpacity(0.30)
                    : Colors.black.withOpacity(0.07),
                blurRadius: _hovering ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: _hovering
                  ? widget.color.withOpacity(0.50)
                  : Colors.transparent,
              width: 1.1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                size: 30,
                color: _hovering
                    ? widget.color
                    : Colors.grey.shade700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: _hovering
                            ? widget.color
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
