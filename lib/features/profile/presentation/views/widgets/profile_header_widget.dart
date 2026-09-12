import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:barnasht_app/features/profile/presentation/views/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({
    super.key,
    required this.colorScheme,
    required this.user,
  });

  final ColorScheme colorScheme;
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final userName = user.name.trim().isEmpty
        ? 'مستخدم برنشتاوي'
        : user.name.trim();

    final email = user.email.trim().isEmpty
        ? 'لم يتم إضافة بريد إلكتروني'
        : user.email.trim();

    final phoneNumber = user.phoneNumber.trim().isEmpty
        ? 'لم يتم إضافة رقم هاتف'
        : user.phoneNumber.trim();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colorScheme.primary.withValues(alpha: 0.12),
            colorScheme.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.18),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 34,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.bold16.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 15,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyles.regular13.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 15,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          phoneNumber,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyles.regular13.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Material(
            color: colorScheme.surface.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(13),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  EditProfileView.routeName,
                  arguments: {
                    'user': user,
                    'profileCubit': context.read<ProfileCubit>(),
                  },
                );
              },
              borderRadius: BorderRadius.circular(13),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
