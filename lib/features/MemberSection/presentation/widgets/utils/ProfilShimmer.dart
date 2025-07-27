import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              decoration: _borderShimmer(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Profile picture placeholder
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name placeholder
                            Container(
                              width: 150,
                              height: 24,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            // Position placeholder
                            Container(
                              width: 100,
                              height: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bio section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 250,
                          height: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Contact info
                    _buildShimmerListItem(),
                    _buildShimmerListItem(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShimmerStatItem(),
                _buildShimmerStatItem(),
                _buildShimmerStatItem(),
              ],
            ),
            const SizedBox(height: 32),

            // Members section header
            Container(
              width: 100,
              height: 20,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 16),
            ),

            // Members list items
            _buildShimmerListItem(),
            _buildShimmerListItem(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _borderShimmer() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color:Colors.grey[100]!
              ,width: 4
              )
            );
  }

  Widget _buildShimmerListItem() {
    return Padding(
      padding: paddingSemetricVertical(),
      child: Container(
        decoration: _borderShimmer(),
        child: Padding(
          padding: paddingSemetricVerticalHorizontal(),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 200,
                height: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerStatItem() {
    return Container(
      decoration: _borderShimmer(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 24,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}