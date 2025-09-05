import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/training_program.dart';
import '../services/training_data_service.dart';

class UploadCertificateDialog extends StatefulWidget {
  final VoidCallback? onTakePhoto;
  final VoidCallback? onBrowseFiles;
  final Function(Map<String, dynamic>)? onSubmit;

  const UploadCertificateDialog({
    Key? key,
    this.onTakePhoto,
    this.onBrowseFiles,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<UploadCertificateDialog> createState() =>
      _UploadCertificateDialogState();
}

class _UploadCertificateDialogState extends State<UploadCertificateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructorController = TextEditingController();
  final _certificateNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _gradeController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingPrograms = true;
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  List<TrainingProgram> _trainingPrograms = [];
  String? _selectedTrainingProgramId;

  @override
  void initState() {
    super.initState();
    _loadTrainingPrograms();
  }

  Future<void> _loadTrainingPrograms() async {
    try {
      final programs = await TrainingDataService.getAllTrainingPrograms();

      print('🔧 Loaded ${programs.length} training programs:');
      for (var program in programs) {
        print('   ${program.id}: ${program.programName}');
      }

      setState(() {
        _trainingPrograms = programs;
        _isLoadingPrograms = false;
      });
    } catch (e) {
      print('❌ Error loading training programs: $e');
      setState(() {
        _isLoadingPrograms = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading training programs: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // More aggressive responsive sizing for smaller screens
    final isSmallScreen =
        screenHeight < 700; // iPhone SE and similar small screens
    final isMediumScreen =
        screenHeight >= 700 && screenHeight < 850; // iPhone 12/13/14

    // Calculate responsive sizes with more aggressive scaling
    final dialogPadding =
        isSmallScreen
            ? 12.0
            : (isMediumScreen ? 14.0 : (isMobile ? 16.0 : 20.0));
    final iconSize =
        isSmallScreen
            ? 20.0
            : (isMediumScreen ? 22.0 : (isMobile ? 24.0 : 32.0));
    final iconPadding =
        isSmallScreen
            ? 8.0
            : (isMediumScreen ? 10.0 : (isMobile ? 12.0 : 16.0));
    final titleFontSize =
        isSmallScreen
            ? 16.0
            : (isMediumScreen ? 17.0 : (isMobile ? 18.0 : 20.0));
    final instructionFontSize =
        isSmallScreen
            ? 11.0
            : (isMediumScreen ? 12.0 : (isMobile ? 13.0 : 14.0));
    final spacing =
        isSmallScreen
            ? 8.0
            : (isMediumScreen ? 10.0 : (isMobile ? 12.0 : 16.0));
    final smallSpacing =
        isSmallScreen ? 4.0 : (isMediumScreen ? 6.0 : (isMobile ? 8.0 : 12.0));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal:
            isSmallScreen ? 8 : (isMediumScreen ? 12 : (isMobile ? 16 : 20)),
        vertical:
            isSmallScreen ? 8 : (isMediumScreen ? 12 : (isMobile ? 16 : 20)),
      ),
      child: Container(
        padding: EdgeInsets.all(dialogPadding),
        constraints: BoxConstraints(
          maxWidth:
              isSmallScreen
                  ? screenWidth * 0.98
                  : (isMediumScreen
                      ? screenWidth * 0.96
                      : (isMobile ? screenWidth * 0.95 : 500)),
          minWidth:
              isSmallScreen
                  ? screenWidth * 0.95
                  : (isMediumScreen
                      ? screenWidth * 0.92
                      : (isMobile ? screenWidth * 0.9 : 320)),
          maxHeight:
              isSmallScreen
                  ? screenHeight * 0.95
                  : (isMediumScreen
                      ? screenHeight * 0.92
                      : (isMobile ? screenHeight * 0.9 : double.infinity)),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8F0), // Light green background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF4CAF50), // Darker green border
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Upload Icon
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.upload_file,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
                SizedBox(height: smallSpacing),

                // Main Title
                Text(
                  'Upload Certificate',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),

                // Instructions
                Text(
                  'Upload your certificate and fill in the details below.',
                  style: TextStyle(
                    fontSize: instructionFontSize,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing),

                // Certificate Details Form
                // Training Program Dropdown (first field as shown in image)
                _buildTrainingProgramDropdown(isMobile, spacing),
                SizedBox(height: spacing),

                _buildTextField(
                  controller: _titleController,
                  label: 'Certificate Title',
                  hint: 'Enter certificate title',
                  icon: Icons.description_outlined,
                  isMobile: isMobile,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter certificate title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing),

                _buildTextField(
                  controller: _instructorController,
                  label: 'Instructor',
                  hint: 'Enter instructor name',
                  icon: Icons.person_outline,
                  isMobile: isMobile,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter instructor name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing),

                _buildTextField(
                  controller: _certificateNumberController,
                  label: 'Certificate Number',
                  hint: 'Enter certificate number',
                  icon: Icons.numbers_outlined,
                  isMobile: isMobile,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter certificate number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing),

                // Responsive layout for date and grade
                isMobile
                    ? Column(
                      children: [
                        _buildTextField(
                          controller: _dateController,
                          label: 'Date Issued',
                          hint: 'MM/DD/YYYY',
                          icon: Icons.calendar_today_outlined,
                          readOnly: true,
                          isMobile: isMobile,
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select date';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: spacing),
                        _buildTextField(
                          controller: _gradeController,
                          label: 'Grade',
                          hint: 'Enter grade (e.g., A, B+, 95%)',
                          icon: Icons.grade_outlined,
                          isMobile: isMobile,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter grade';
                            }
                            return null;
                          },
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _dateController,
                            label: 'Date Issued',
                            hint: 'MM/DD/YYYY',
                            icon: Icons.calendar_today_outlined,
                            readOnly: true,
                            isMobile: isMobile,
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select date';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: _buildTextField(
                            controller: _gradeController,
                            label: 'Grade',
                            hint: 'Enter grade (e.g., A, B+, 95%)',
                            icon: Icons.grade_outlined,
                            isMobile: isMobile,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter grade';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                SizedBox(height: spacing),

                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter certificate description',
                  icon: Icons.description_outlined,
                  isMobile: isMobile,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing),

                // File Upload Section
                Container(
                  padding: EdgeInsets.all(
                    isSmallScreen
                        ? 8
                        : (isMediumScreen ? 10 : (isMobile ? 12 : 16)),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Upload Certificate File',
                        style: TextStyle(
                          fontSize:
                              isSmallScreen
                                  ? 12
                                  : (isMediumScreen
                                      ? 13
                                      : (isMobile ? 14 : 16)),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        height:
                            isSmallScreen
                                ? 4
                                : (isMediumScreen ? 5 : (isMobile ? 6 : 8)),
                      ),
                      Text(
                        'JPEG, PNG, and PDF formats up to 50 MB.',
                        style: TextStyle(
                          fontSize:
                              isSmallScreen
                                  ? 9
                                  : (isMediumScreen
                                      ? 10
                                      : (isMobile ? 11 : 12)),
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height:
                            isSmallScreen
                                ? 8
                                : (isMediumScreen ? 10 : (isMobile ? 12 : 16)),
                      ),

                      // Selected file display
                      if (_selectedFile != null) ...[
                        Container(
                          padding: EdgeInsets.all(
                            isSmallScreen ? 6 : (isMediumScreen ? 8 : 10),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getFileIcon(_selectedFile!.path),
                                color: Colors.green,
                                size: isSmallScreen ? 16 : 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedFile!.path.split('/').last,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 11 : 12,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFile = null;
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.green.shade700,
                                  size: isSmallScreen ? 16 : 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                      ],

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.camera_alt_outlined,
                              text: 'Take photo',
                              isMobile: isMobile,
                              onTap: _takePhoto,
                            ),
                          ),
                          SizedBox(
                            width:
                                isSmallScreen
                                    ? 6
                                    : (isMediumScreen
                                        ? 7
                                        : (isMobile ? 8 : 12)),
                          ),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.upload_file_outlined,
                              text: 'Browse Files (Images & PDF)',
                              isMobile: isMobile,
                              onTap: _pickFile,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height:
                      isSmallScreen
                          ? 38
                          : (isMediumScreen ? 40 : (isMobile ? 44 : 48)),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child:
                        _isLoading
                            ? SizedBox(
                              height: isMobile ? 18 : 20,
                              width: isMobile ? 18 : 20,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              'Submit Certificate',
                              style: TextStyle(
                                fontSize:
                                    isSmallScreen
                                        ? 13
                                        : (isMediumScreen
                                            ? 14
                                            : (isMobile ? 15 : 16)),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingProgramDropdown(bool isMobile, double spacing) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final isMediumScreen = screenHeight >= 700 && screenHeight < 850;

    final labelFontSize =
        isSmallScreen
            ? 11.0
            : (isMediumScreen ? 12.0 : (isMobile ? 13.0 : 14.0));
    final iconSize =
        isSmallScreen
            ? 16.0
            : (isMediumScreen ? 17.0 : (isMobile ? 18.0 : 20.0));
    final contentPadding =
        isSmallScreen
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
            : (isMediumScreen
                ? const EdgeInsets.symmetric(horizontal: 11, vertical: 9)
                : (isMobile
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                    : const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    )));

    return Theme(
      data: Theme.of(context).copyWith(
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(
            fontSize: labelFontSize,
            color: const Color(0xFF4CAF50),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedTrainingProgramId,
        decoration: InputDecoration(
          labelText: 'Training Program',
          labelStyle: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4CAF50),
          ),
          hintText:
              _isLoadingPrograms
                  ? 'Loading programs...'
                  : 'Select training program',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: labelFontSize,
          ),
          prefixIcon: Icon(
            Icons.school_outlined,
            color: const Color(0xFF4CAF50),
            size: iconSize,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade300, width: 1),
          ),
          contentPadding: contentPadding,
        ),
        items:
            _trainingPrograms.map((program) {
              return DropdownMenuItem<String>(
                value: program.id,
                child: Text(
                  program.programName,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
        onChanged:
            _isLoadingPrograms
                ? null
                : (String? newValue) {
                  setState(() {
                    _selectedTrainingProgramId = newValue;
                  });
                },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a training program';
          }
          return null;
        },
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down, color: const Color(0xFF4CAF50)),
        dropdownColor: Colors.white,
        style: TextStyle(
          fontSize: labelFontSize,
          color: const Color(0xFF4CAF50),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isMobile,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final isMediumScreen = screenHeight >= 700 && screenHeight < 850;

    final labelFontSize =
        isSmallScreen
            ? 11.0
            : (isMediumScreen ? 12.0 : (isMobile ? 13.0 : 14.0));
    final hintFontSize =
        isSmallScreen
            ? 11.0
            : (isMediumScreen ? 12.0 : (isMobile ? 13.0 : 14.0));
    final iconSize =
        isSmallScreen
            ? 16.0
            : (isMediumScreen ? 17.0 : (isMobile ? 18.0 : 20.0));
    final contentPadding =
        isSmallScreen
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
            : (isMediumScreen
                ? const EdgeInsets.symmetric(horizontal: 11, vertical: 9)
                : (isMobile
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                    : const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    )));

    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: validator,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4CAF50),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: hintFontSize,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF4CAF50),
            size: iconSize,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade300, width: 1),
          ),
          contentPadding: contentPadding,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _selectedFile = File(photo.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      // Show file type selection dialog
      final String? fileType = await _showFileTypeDialog();
      if (fileType == null) return;

      if (fileType == 'image') {
        // Pick image from gallery
        final XFile? file = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (file != null) {
          setState(() {
            _selectedFile = File(file.path);
          });
        }
      } else if (fileType == 'pdf') {
        // Pick PDF file
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false,
        );
        if (result != null && result.files.single.path != null) {
          setState(() {
            _selectedFile = File(result.files.single.path!);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getFileIcon(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<String?> _showFileTypeDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select File Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: Color(0xFF4CAF50)),
                title: const Text('Image'),
                subtitle: const Text('JPG, PNG, GIF, WebP'),
                onTap: () => Navigator.of(context).pop('image'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Color(0xFF4CAF50),
                ),
                title: const Text('PDF Document'),
                subtitle: const Text('PDF files'),
                onTap: () => Navigator.of(context).pop('pdf'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a file to upload'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedTrainingProgramId == null ||
          _selectedTrainingProgramId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a training program'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Get the selected training program
      final selectedProgram = _trainingPrograms.firstWhere(
        (program) => program.id == _selectedTrainingProgramId,
        orElse: () => _trainingPrograms.first,
      );

      // Prepare certificate data
      final certificateData = {
        'file': _selectedFile!,
        'certificateTitle': _titleController.text,
        'instructor': _instructorController.text,
        'certificateNumber': _certificateNumberController.text,
        'dateIssued': _dateController.text,
        'trainingProgramName': selectedProgram.programName,
      };

      print('🔧 Certificate data being sent:');
      print('   Training Program ID: ${_selectedTrainingProgramId}');
      print('   Training Program Name: ${selectedProgram.programName}');
      print('   Available programs count: ${_trainingPrograms.length}');
      print(
        '   Available programs: ${_trainingPrograms.map((p) => '${p.id}: ${p.programName}').join(', ')}',
      );

      try {
        // Call the onSubmit callback
        await widget.onSubmit?.call(certificateData);
      } catch (e) {
        // Handle any errors from the upload
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        // Reset loading state
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructorController.dispose();
    _certificateNumberController.dispose();
    _dateController.dispose();
    _gradeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isMobile;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.isMobile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final isMediumScreen = screenHeight >= 700 && screenHeight < 850;

    final iconSize =
        isSmallScreen
            ? 14.0
            : (isMediumScreen ? 15.0 : (isMobile ? 16.0 : 18.0));
    final fontSize =
        isSmallScreen
            ? 10.0
            : (isMediumScreen ? 11.0 : (isMobile ? 12.0 : 13.0));
    final padding =
        isSmallScreen
            ? const EdgeInsets.symmetric(vertical: 6, horizontal: 8)
            : (isMediumScreen
                ? const EdgeInsets.symmetric(vertical: 7, horizontal: 9)
                : (isMobile
                    ? const EdgeInsets.symmetric(vertical: 8, horizontal: 10)
                    : const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    )));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.black87),
            SizedBox(
              width:
                  isSmallScreen ? 3 : (isMediumScreen ? 4 : (isMobile ? 4 : 6)),
            ),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
