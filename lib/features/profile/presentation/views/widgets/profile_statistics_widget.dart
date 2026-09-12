import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_state_card.dart';
import 'package:flutter/material.dart';

class ProfileStatisticsWidget extends StatelessWidget {
  const ProfileStatisticsWidget({
    super.key,
    required this.colorScheme,
    required this.approvedCount,
    required this.pendingCount,
    required this.rejectedCount,
  });

  final ColorScheme colorScheme;
  final int approvedCount;
  final int pendingCount;
  final int rejectedCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProfileStatCard(
            icon: Icons.check_circle_outline_rounded,
            value: '$approvedCount',
            title: 'مقبولة',
            color: Colors.green,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: ProfileStatCard(
            icon: Icons.access_time_rounded,
            value: '$pendingCount',
            title: 'قيد المراجعة',
            color: Colors.orange,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: ProfileStatCard(
            icon: Icons.cancel_outlined,
            value: '$rejectedCount',
            title: 'مرفوضة',
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}