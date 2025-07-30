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
  late List<TrainingProgram> _allTrainingPrograms;

  @override
  void initState() {
    super.initState();
    _allTrainingPrograms = TrainingDataService.getAllTrainingPrograms();
  }

  List<TrainingProgram> get _filteredPrograms {
    return TrainingDataService.getFilteredPrograms(
      _allTrainingPrograms,
      _selectedFilterIndex,
    );
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
            child: Row(
              children: [
                Expanded(
                  child: TrainingFilterButton(
                    text: 'All Programs',
                    isSelected: _selectedFilterIndex == 0,
                    onTap: () => setState(() => _selectedFilterIndex = 0),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 12),
                Expanded(
                  child: TrainingFilterButton(
                    text: 'Available',
                    isSelected: _selectedFilterIndex == 1,
                    onTap: () => setState(() => _selectedFilterIndex = 1),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 12),
                Expanded(
                  child: TrainingFilterButton(
                    text: 'In Progress',
                    isSelected: _selectedFilterIndex == 2,
                    onTap: () => setState(() => _selectedFilterIndex = 2),
                  ),
                ),
              ],
            ),
          ),
          // Training Programs List
          Expanded(
            child:
                _filteredPrograms.isEmpty
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
}
