import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/cities_content.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/cities_search_bar.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/cities_sort_button.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/offline_banner.dart';

/// City List screen displaying current weather for 10 Brazilian cities.
///
/// Features:
/// - Search bar for accent-insensitive city name filtering
/// - Pull-to-refresh for manual data sync
/// - Offline banner when connectivity is lost
/// - Shimmer skeleton loading on first load
/// - Error state with retry when no cached data
/// - Snackbar on background refresh error
class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final textStyles = context.hublaTextStyles;
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<CitiesCubit>();

    return BlocPresentationListener<CitiesCubit, CitiesPresentationEvent>(
      listener: (context, event) => switch (event) {
        RefreshErrorEvent(:final errorMessage) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            backgroundColor: colors.danger,
          ),
        ),
      },
      child: BlocBuilder<CitiesCubit, CitiesState>(
        builder: (context, state) => DecoratedBox(
          decoration: BoxDecoration(gradient: colors.backgroundGradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                l10n.cities,
                style: textStyles.headlineMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              centerTitle: false,
            ),
            body: Column(
              children: [
                if (state.isOffline) const OfflineBanner(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CitiesSearchBar(onChanged: cubit.updateSearchQuery),
                    ),
                    CitiesSortButton(
                      sortCriteria: state.sortCriteria,
                      isAscending: state.isAscending,
                      onSort: cubit.updateSort,
                      onClearSort: cubit.clearSort,
                    ),
                  ],
                ),
                Expanded(
                  child: CitiesContent(state: state, cubit: cubit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
