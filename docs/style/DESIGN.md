---
name: Archaeo Field Kit
colors:
  surface: '#fff8f5'
  surface-dim: '#dfd9d6'
  surface-bright: '#fff8f5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f9f2ef'
  surface-container: '#f3ecea'
  surface-container-high: '#eee7e4'
  surface-container-highest: '#e8e1de'
  on-surface: '#1e1b1a'
  on-surface-variant: '#4e453e'
  inverse-surface: '#33302e'
  inverse-on-surface: '#f6efec'
  outline: '#80756d'
  outline-variant: '#d2c4bb'
  surface-tint: '#705a49'
  primary: '#312113'
  on-primary: '#ffffff'
  primary-container: '#493627'
  on-primary-container: '#ba9f8b'
  inverse-primary: '#dec1ac'
  secondary: '#685c54'
  on-secondary: '#ffffff'
  secondary-container: '#eddcd2'
  on-secondary-container: '#6c6058'
  tertiary: '#15272a'
  on-tertiary: '#ffffff'
  tertiary-container: '#2b3d40'
  on-tertiary-container: '#94a7ab'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#fbddc7'
  primary-fixed-dim: '#dec1ac'
  on-primary-fixed: '#28180b'
  on-primary-fixed-variant: '#574333'
  secondary-fixed: '#f0dfd5'
  secondary-fixed-dim: '#d3c3ba'
  on-secondary-fixed: '#221a14'
  on-secondary-fixed-variant: '#50453d'
  tertiary-fixed: '#d2e6ea'
  tertiary-fixed-dim: '#b6cace'
  on-tertiary-fixed: '#0c1e21'
  on-tertiary-fixed-variant: '#384a4d'
  background: '#fff8f5'
  on-background: '#1e1b1a'
  surface-variant: '#e8e1de'
typography:
  display-bold:
    fontFamily: Inter
    fontSize: 1.5rem
    fontWeight: '700'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Inter
    fontSize: 1.125rem
    fontWeight: '700'
    lineHeight: '1.2'
  body-base:
    fontFamily: Inter
    fontSize: 0.875rem
    fontWeight: '500'
    lineHeight: '1.5'
  label-caps:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '700'
    lineHeight: '1'
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Inter
    fontSize: 0.75rem
    fontWeight: '600'
    lineHeight: '1'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-padding: 1rem
  stack-gap: 1rem
  section-gap: 1.5rem
  element-padding-y: 0.875rem
  element-padding-x: 1rem
---

## Brand & Style
The brand identity for **Archaeo Field Kit** is "Sophisticated Utilitarian." It bridges the gap between rugged field work and scholarly precision. The design style is **Corporate Modern with a Tactile Twist**, emphasizing reliability, organizational clarity, and a professional academic tone. 

The visual language uses high-contrast typography and earthy primary tones to evoke a sense of heritage and discovery, while maintaining a clean, systematic interface suitable for high-stakes data collection. The UI should feel like a premium digital ledger—efficient, grounded, and authoritative.

## Colors
The palette is rooted in an "Earth Fidelity" scheme. The **Primary (#493627)** is a deep, clay-like brown used for structural elements, headers, and primary actions, providing a stable foundation. 

- **Backgrounds:** A warm neutral off-white is used for the light mode to reduce glare during field use, while the dark mode utilizes a deep charcoal.
- **Surface Tints:** We use low-opacity overlays of the primary color (5% and 20%) to create tonal containers that feel integrated with the brand color rather than using generic grays.
- **Functional Accents:** High-visibility red is reserved strictly for destructive actions or critical system alerts.

## Typography
We employ **Inter** across all levels to maintain a systematic, utilitarian aesthetic. The hierarchy is defined by aggressive weight changes rather than massive size shifts.

- **Headlines:** Use Bold (700) weights with tight tracking to command authority.
- **Body:** Set at 14px (0.875rem) for high information density without sacrificing legibility.
- **Navigation/Status:** Uses uppercase "Label Caps" with increased letter spacing for a technical, mapped feel.
- **Contrast:** Secondary information is distinguished via opacity (70%) rather than lighter font weights to ensure readability.

## Layout & Spacing
The system follows a **Mobile-First Fixed Grid** philosophy, constrained within a maximum width for tablet/desktop to maintain focus. 

- **Padding:** A standard 16px (1rem) margin is applied to the main viewport.
- **Grouping:** Related elements are grouped in cards with 4px (0.25rem) internal gaps, while major sections are separated by 24px (1.5rem).
- **Sticky Elements:** Headers and navigation are fixed to the viewport to provide constant context during scrolling.

## Elevation & Depth
Depth is communicated through **Tonal Layering** and **Subtle Outlines** rather than heavy shadows.

- **Level 0:** The main application background (warm neutral).
- **Level 1:** Content cards use a white background with a very subtle 1px border (`border-primary/10`).
- **Level 2:** Interactive metrics boxes use a tinted background (`primary/5`) to sit "inside" the layout.
- **Shadows:** Reserved only for high-priority floating elements or the primary container shadow (`shadow-xl`) to lift the app interface off the physical screen background.

## Shapes
The shape language is "Approachable Geometric." 

- **Containers:** Large sections and cards use `rounded-xl` (1.5rem / 24px) to soften the professional tone.
- **Buttons/Inputs:** Use `rounded-xl` for a consistent, modern touch-target feel.
- **Avatars/Badges:** Utilize full-circle `rounded-full` to provide a distinct contrast against the predominantly rectangular layout.
- **Borders:** All borders are kept thin (1px to 2px) to maintain a precise, technical look.

## Components
- **Buttons:** Primary buttons are outlined or filled with the brand color, featuring 14px bold text. Secondary buttons for dangerous actions use a light red wash with bold red text.
- **Toggles:** Use a pill-shaped track with a high-contrast white thumb. The track color changes to the primary brand color when active.
- **Metrics Cards:** Large-format numbers (24px) paired with uppercase, muted semantic labels.
- **List Items:** Enclosed in a single card container with 1px `primary/5` dividers between items to reduce visual noise.
- **Badges:** Small, pill-shaped markers with uppercase text, used for status indicators like "Arqueólogo".
- **Bottom Navigation:** Clean icons with 10px bold uppercase labels, using color (Primary vs. Muted) to indicate active state.