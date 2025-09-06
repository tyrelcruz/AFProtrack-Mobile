import 'package:flutter/material.dart';

class SkeletonLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
              stops:
                  [
                    _animation.value - 0.3,
                    _animation.value,
                    _animation.value + 0.3,
                  ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

// Skeleton for training program cards
class TrainingProgramSkeleton extends StatelessWidget {
  const TrainingProgramSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program header with icon and name
          Row(
            children: [
              SkeletonLoading(
                width: 28,
                height: 28,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoading(
                      width: double.infinity,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    SkeletonLoading(
                      width: 120,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              SkeletonLoading(
                width: 60,
                height: 20,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress section
          Row(
            children: [
              SkeletonLoading(
                width: 50,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
              const Spacer(),
              SkeletonLoading(
                width: 30,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: 3),

          // Progress bar
          SkeletonLoading(
            width: double.infinity,
            height: 5,
            borderRadius: BorderRadius.circular(2.5),
          ),
          const SizedBox(height: 3),

          // Grade section
          Row(
            children: [
              const Spacer(),
              SkeletonLoading(
                width: 60,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Skeleton for progress bars
class ProgressBarSkeleton extends StatelessWidget {
  const ProgressBarSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress label and percentage
        Row(
          children: [
            SkeletonLoading(
              width: 80,
              height: 14,
              borderRadius: BorderRadius.circular(4),
            ),
            const Spacer(),
            SkeletonLoading(
              width: 40,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Progress bar
        SkeletonLoading(
          width: double.infinity,
          height: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

// Skeleton for career progression card
class CareerProgressionSkeleton extends StatelessWidget {
  const CareerProgressionSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            SkeletonLoading(
              width: 180,
              height: 20,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),

            // Current rank section
            Row(
              children: [
                SkeletonLoading(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoading(
                        width: 120,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoading(
                        width: 80,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress section
            Row(
              children: [
                SkeletonLoading(
                  width: 60,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const Spacer(),
                SkeletonLoading(
                  width: 40,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SkeletonLoading(
              width: double.infinity,
              height: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),

            // Next rank section
            Row(
              children: [
                SkeletonLoading(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoading(
                        width: 140,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoading(
                        width: 100,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Skeleton for training stats grid
class TrainingStatsSkeleton extends StatelessWidget {
  const TrainingStatsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            SkeletonLoading(
              width: 150,
              height: 20,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),

            // Stats grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: List.generate(4, (index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonLoading(
                        width: 24,
                        height: 24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(height: 8),
                      SkeletonLoading(
                        width: 30,
                        height: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoading(
                        width: 60,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Skeleton for profile overview section
class ProfileOverviewSkeleton extends StatelessWidget {
  const ProfileOverviewSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Row(
              children: [
                SkeletonLoading(
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoading(
                        width: 120,
                        height: 18,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoading(
                        width: 100,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      SkeletonLoading(
                        width: 80,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress sections
            const ProgressBarSkeleton(),
            const SizedBox(height: 16),
            const ProgressBarSkeleton(),
          ],
        ),
      ),
    );
  }
}
