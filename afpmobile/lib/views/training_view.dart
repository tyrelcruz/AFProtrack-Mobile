import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/training_filter_button.dart';
import '../widgets/training_program_card.dart';
import '../widgets/training_details_modal.dart';
import '../widgets/training_empty_state.dart';
import '../models/training_program.dart';
import '../services/training_data_service.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({Key? key}) : super(key: key);

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {
  int _selectedFilterIndex = 0;
  List<TrainingProgram> _allTrainingPrograms = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrainingPrograms();
  }

  Future<void> _loadTrainingPrograms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final programs = await TrainingDataService.getAllTrainingPrograms();
      print('=== DEBUG: Training View Data Loading ===');
      print('Programs loaded: ${programs.length}');
      for (var program in programs) {
        print(
          'Loaded program: ${program.programName}, Status: "${program.status}"',
        );
      }
      print('=== END DEBUG ===');

      setState(() {
        _allTrainingPrograms = programs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load training programs: $e';
        _isLoading = false;
      });
    }
  }

  List<TrainingProgram> get _filteredPrograms {
    print('=== DEBUG: Training View Filtering ===');
    print('Selected filter index: $_selectedFilterIndex');
    print('Total programs loaded: ${_allTrainingPrograms.length}');

    final filtered = TrainingDataService.getFilteredPrograms(
      _allTrainingPrograms,
      _selectedFilterIndex,
    );

    print('Filtered programs count: ${filtered.length}');
    print('=== END DEBUG ===');

    return filtered;
  }

  void _showTrainingDetails(TrainingProgram program) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TrainingDetailsModal(program: program);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trainingBackground,
      appBar: const AppBarWidget(title: 'Training', showLeading: false),
      body: Column(
        children: [
          // Filter Bar
          Container(
            color: AppColors.trainingBackground,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsivePadding(context),
              vertical: 12,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // All
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TrainingFilterButton(
                      text: 'All',
                      isSelected: _selectedFilterIndex == 0,
                      onTap: () => setState(() => _selectedFilterIndex = 0),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TrainingFilterButton(
                      text: 'Available',
                      isSelected: _selectedFilterIndex == 1,
                      onTap: () => setState(() => _selectedFilterIndex = 1),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TrainingFilterButton(
                      text: 'In Progress',
                      isSelected: _selectedFilterIndex == 2,
                      onTap: () => setState(() => _selectedFilterIndex = 2),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TrainingFilterButton(
                      text: 'Upcoming',
                      isSelected: _selectedFilterIndex == 3,
                      onTap: () => setState(() => _selectedFilterIndex = 3),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TrainingFilterButton(
                      text: 'Completed',
                      isSelected: _selectedFilterIndex == 4,
                      onTap: () => setState(() => _selectedFilterIndex = 4),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 12),
                  // More (Cancelled, Dropped)
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TrainingFilterButton(
                      text: 'More',
                      isSelected:
                          _selectedFilterIndex == 5 ||
                          _selectedFilterIndex == 6,
                      onTap: _openMoreFilters,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Training Programs List
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
                            onPressed: _loadTrainingPrograms,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                    : _filteredPrograms.isEmpty
                    ? TrainingEmptyState(message: _getEmptyStateMessage())
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getResponsivePadding(
                          context,
                        ),
                        vertical: 12,
                      ),
                      itemCount: _filteredPrograms.length,
                      itemBuilder: (context, index) {
                        return TrainingProgramCard(
                          program: _filteredPrograms[index],
                          onViewDetails:
                              () => _showTrainingDetails(
                                _filteredPrograms[index],
                              ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    return TrainingDataService.getEmptyStateMessage(_selectedFilterIndex);
  }

  void _openMoreFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Cancelled'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedFilterIndex = 5);
                },
                trailing:
                    _selectedFilterIndex == 5
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
              ),
              ListTile(
                title: const Text('Dropped'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedFilterIndex = 6);
                },
                trailing:
                    _selectedFilterIndex == 6
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
