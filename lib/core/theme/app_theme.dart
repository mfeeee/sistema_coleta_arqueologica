import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(brightness: Brightness.light);
  static ThemeData get dark => _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final bool isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? const ColorScheme(
            brightness: Brightness.dark,
            primary: AppColorsDark.primary,
            onPrimary: AppColorsDark.onPrimary,
            primaryContainer: AppColorsDark.primaryContainer,
            onPrimaryContainer: AppColorsDark.onPrimaryContainer,
            secondary: AppColorsDark.secondary,
            onSecondary: AppColorsDark.onSecondary,
            secondaryContainer: AppColorsDark.secondaryContainer,
            onSecondaryContainer: AppColorsDark.onSecondaryContainer,
            tertiary: AppColorsDark.tertiary,
            onTertiary: AppColorsDark.onTertiary,
            tertiaryContainer: AppColorsDark.tertiaryContainer,
            onTertiaryContainer: AppColorsDark.onTertiaryContainer,
            error: AppColorsDark.error,
            onError: AppColorsDark.onError,
            errorContainer: AppColorsDark.errorContainer,
            onErrorContainer: AppColorsDark.onErrorContainer,
            surface: AppColorsDark.surface,
            onSurface: AppColorsDark.onSurface,
            onSurfaceVariant: AppColorsDark.onSurfaceVariant,
            outline: AppColorsDark.outline,
            outlineVariant: AppColorsDark.outlineVariant,
            inverseSurface: AppColorsDark.inverseSurface,
            onInverseSurface: AppColorsDark.inverseOnSurface,
            inversePrimary: AppColorsDark.inversePrimary,
            surfaceTint: AppColorsDark.surfaceTint,
            scrim: Colors.black,
            shadow: Colors.black,
          )
        : const ColorScheme(
            brightness: Brightness.light,
            primary: AppColorsLight.primary,
            onPrimary: AppColorsLight.onPrimary,
            primaryContainer: AppColorsLight.primaryContainer,
            onPrimaryContainer: AppColorsLight.onPrimaryContainer,
            secondary: AppColorsLight.secondary,
            onSecondary: AppColorsLight.onSecondary,
            secondaryContainer: AppColorsLight.secondaryContainer,
            onSecondaryContainer: AppColorsLight.onSecondaryContainer,
            tertiary: AppColorsLight.tertiary,
            onTertiary: AppColorsLight.onTertiary,
            tertiaryContainer: AppColorsLight.tertiaryContainer,
            onTertiaryContainer: AppColorsLight.onTertiaryContainer,
            error: AppColorsLight.error,
            onError: AppColorsLight.onError,
            errorContainer: AppColorsLight.errorContainer,
            onErrorContainer: AppColorsLight.onErrorContainer,
            surface: AppColorsLight.surface,
            onSurface: AppColorsLight.onSurface,
            onSurfaceVariant: AppColorsLight.onSurfaceVariant,
            outline: AppColorsLight.outline,
            outlineVariant: AppColorsLight.outlineVariant,
            inverseSurface: AppColorsLight.inverseSurface,
            onInverseSurface: AppColorsLight.inverseOnSurface,
            inversePrimary: AppColorsLight.inversePrimary,
            surfaceTint: AppColorsLight.surfaceTint,
            scrim: Colors.black,
            shadow: Colors.black,
          );

    final double radiusXl = isDark ? AppRadius.xlDark : AppRadius.xl;
    final double radiusDef = isDark ? AppRadius.defDark : AppRadius.base;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        color: isDark
            ? AppColorsDark.surfaceContainerLow
            : AppColorsLight.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: AppTextStyles.bodyBase.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusXl),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.elementPaddingY,
            horizontal: AppSpacing.elementPaddingX,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppTextStyles.bodyBase.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusXl),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.elementPaddingY,
            horizontal: AppSpacing.elementPaddingX,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.elementPaddingY,
          horizontal: AppSpacing.elementPaddingX,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusDef),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusDef),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusDef),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: AppTextStyles.labelSm.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: AppTextStyles.bodyBase.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? AppColorsDark.surfaceContainerLow
            : AppColorsLight.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.headlineMd.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? AppColorsDark.surfaceContainer
            : AppColorsLight.surfaceContainer,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onPrimaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelCaps.copyWith(
              color: colorScheme.onPrimaryContainer,
            );
          }
          return AppTextStyles.labelCaps.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(thickness: 1, space: 1),
      textTheme:
          const TextTheme(
            displayLarge: AppTextStyles.displayBold,
            titleLarge: AppTextStyles.headlineMd,
            bodyMedium: AppTextStyles.bodyBase,
            labelSmall: AppTextStyles.labelCaps,
            labelMedium: AppTextStyles.labelSm,
          ).apply(
            bodyColor: colorScheme.onSurface,
            displayColor: colorScheme.onSurface,
          ),
    );
  }
}
