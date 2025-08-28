import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/app_colors.dart';
import '../widgets/schedule_details_modal.dart';
import '../models/schedule_program.dart';
import '../services/schedule_data_service.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  int _selectedTabIndex = 0;
  List<ScheduleProgram> _allSchedulePrograms = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSchedulePrograms();
  }

  Future<void> _loadSchedulePrograms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final programs = await ScheduleDataService.getMyTrainingPrograms();

      setState(() {
        _allSchedulePrograms = programs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load schedule programs: $e';
        _isLoading = false;
      });
    }
  }

  List<ScheduleProgram> get _filteredPrograms {
    return ScheduleDataService.getFilteredPrograms(
      _allSchedulePrograms,
      _selectedTabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(title: 'Schedule', showLeading: false),
      body: Column(
        children: [
          Container(
            color: AppColors.appBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    text: 'My Schedule',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    text: 'Ongoing',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    text: 'Completed',
                    isSelected: _selectedTabIndex == 2,
                    onTap: () => setState(() => _selectedTabIndex = 2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadSchedulePrograms,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                    : _filteredPrograms.isEmpty
                    ? Center(
                      child: Text(
                        ScheduleDataService.getEmptyStateMessage(
                          _selectedTabIndex,
                        ),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                    : _ScheduleList(programs: _filteredPrograms),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3E503A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected
                  ? null
                  : Border.all(
                    color: const Color(0xFFC4C4C4).withOpacity(0.4),
                    width: 1.5,
                  ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF3E503A),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<ScheduleProgram> programs;

  const _ScheduleList({required this.programs});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      children:
          programs.map((program) => _ScheduleCard(program: program)).toList(),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ScheduleProgram program;

  const _ScheduleCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (ctx) => ScheduleDetailsModal(
                title: program.programName,
                dateTimeRange: program.dateTimeRange,
                badge: program.badgeText,
                instructor: program.instructor,
                location: program.venue,
                trainingComplete: program.isTrainingComplete,
              ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 7),
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (program.isTrainingComplete)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Training Complete',
                    style: TextStyle(
                      color: Color(0xFF3E503A),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              if (program.dateTimeRange.isNotEmpty)
                Text(
                  program.dateTimeRange,
                  style: TextStyle(
                    color: Color(0xFF0B6000),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (program.dateTimeRange.isNotEmpty) SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      program.programName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: program.badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      program.badgeText,
                      style: TextStyle(
                        color: program.badgeTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                'Instructor: ${program.instructor}',
                style: TextStyle(
                  color: Color(0xFF8B8B8B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                program.venue,
                style: TextStyle(
                  color: Color(0xFF8B8B8B),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
