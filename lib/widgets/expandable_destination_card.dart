import 'package:flutter/material.dart';

class ExpandableDestinationCard extends StatefulWidget {
  final String name;
  final String country;
  final String description;
  final String info;
  final List<Color> gradientColors;
  final IconData icon;
  final bool initiallyExpanded;
  final VoidCallback? onTap;

  const ExpandableDestinationCard({
    super.key,
    required this.name,
    required this.country,
    required this.description,
    required this.info,
    required this.gradientColors,
    required this.icon,
    this.initiallyExpanded = false,
    this.onTap,
  });

  @override
  State<ExpandableDestinationCard> createState() => _ExpandableDestinationCardState();
}

class _ExpandableDestinationCardState extends State<ExpandableDestinationCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    // If initially expanded, start with forward animation
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ExpandableDestinationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update expansion state when parent changes it
    if (widget.initiallyExpanded != oldWidget.initiallyExpanded) {
      setState(() {
        _isExpanded = widget.initiallyExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      // Fallback to internal toggle if no external callback
      _toggleExpanded();
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient - always visible
            Container(
              constraints: const BoxConstraints(minHeight: 70),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: _isExpanded ? Radius.zero : const Radius.circular(16),
                  bottomRight: _isExpanded ? Radius.zero : const Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.gradientColors[1], // Đậm hơn ở trên
                    widget.gradientColors[0], // Nhạt hơn ở dưới
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                fontFamily: 'BalooBhaijaan2',
                                fontSize: 20, // Increased from 18 to 20
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              widget.country,
                              style: const TextStyle(
                                fontFamily: 'BalooBhaijaan2',
                                fontSize: 14, // Increased from 12 to 14
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expandable Content - only visible when expanded
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isExpanded ? null : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isExpanded ? 1.0 : 0.0,
                child: _isExpanded 
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.description,
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 16, // Increased from 14 to 16
                              height: 1.5, // Increased line height for better readability
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 10), // Increased spacing
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Increased padding
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F7FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.info,
                              style: const TextStyle(
                                fontFamily: 'BalooBhaijaan2',
                                fontSize: 14, // Increased from 12 to 14
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
