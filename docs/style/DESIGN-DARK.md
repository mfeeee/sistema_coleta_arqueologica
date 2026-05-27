---
name: Archaeo Field Kit
colors:
  surface: '#151311'
  surface-dim: '#151311'
  surface-bright: '#3c3837'
  surface-container-lowest: '#100e0c'
  surface-container-low: '#1e1b1a'
  surface-container: '#221f1e'
  surface-container-high: '#2c2928'
  surface-container-highest: '#373432'
  on-surface: '#e8e1de'
  on-surface-variant: '#d2c4bb'
  inverse-surface: '#e8e1de'
  inverse-on-surface: '#33302e'
  outline: '#9b8e86'
  outline-variant: '#4e453e'
  surface-tint: '#dec1ac'
  primary: '#dec1ac'
  on-primary: '#3f2d1e'
  primary-container: '#493627'
  on-primary-container: '#ba9f8b'
  inverse-primary: '#705a49'
  secondary: '#d3c3ba'
  on-secondary: '#382e28'
  secondary-container: '#50453d'
  on-secondary-container: '#c2b2a9'
  tertiary: '#b6cace'
  on-tertiary: '#213336'
  tertiary-container: '#2b3d40'
  on-tertiary-container: '#94a7ab'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
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
  background: '#151311'
  on-background: '#e8e1de'
  surface-variant: '#373432'
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
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
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
The palette is rooted in an "Earth Fidelity" scheme, now optimized for a **Dark Mode** environment to reduce eye strain during late-night field documentation or low-light excavation settings. The **Primary (#493627)** is a deep, clay-like brown that serves as the foundation for structural elements and brand presence.

- **Backgrounds:** A deep charcoal/near-black base is used to provide maximum contrast for data entry, ensuring that text and UI elements remain legible in high-glare or dark environments.
- **Surface Tints:** We use low-opacity overlays of the primary color (5% and 20%) to create tonal containers that feel integrated with the brand color rather than using generic grays.
- **Functional Accents:** High-visibility red is reserved strictly for destructive actions or critical system alerts, cutting through the dark background with high prominence.

## Typography
We employ **Inter** across all levels to maintain a systematic, utilitarian aesthetic. The hierarchy is defined by aggressive weight changes rather than massive size shifts.

- **Headlines:** Use Bold (700) weights with tight tracking to command authority.
- **Body:** Set at 14px (0.875rem) for high information density without sacrificing legibility.
- **Navigation/Status:** Uses uppercase "Label Caps" with increased letter spacing for a technical, mapped feel.
- **Contrast:** Secondary information is distinguished via opacity (70%) rather than lighter font weights to ensure readability in the dark UI.

## Layout & Spacing
The system follows a **Mobile-First Fixed Grid** philosophy, constrained within a maximum width for tablet/desktop to maintain focus. 

- **Padding:** A standard 16px (1rem) margin is applied to the main viewport.
- **Grouping:** Related elements are grouped in cards with 4px (0.25rem) internal gaps, while major sections are separated by 24px (1.5rem).
- **Sticky Elements:** Headers and navigation are fixed to the viewport to provide constant context during scrolling.

## Elevation & Depth
Depth is communicated through **Tonal Layering** and **Subtle Outlines** rather than heavy shadows, which is especially effective in dark mode.

- **Level 0:** The main application background (deep charcoal).
- **Level 1:** Content cards use a slightly lighter container surface with a very subtle 1px border (`border-primary/10`).
- **Level 2:** Interactive metrics boxes use a tinted background (`primary/10`) to sit "inside" the layout.
- **Shadows:** Minimal usage. Depth is primarily achieved through shifting background luma levels to distinguish foreground from background.

## Shapes
The shape language is **"Pill-Shaped and Fluid."** By utilizing a high roundedness factor, the interface softens its utilitarian edge with a more modern, ergonomic feel that suggests ease of handling in the field.

- **Containers:** Large sections and cards use `rounded-xl` (3rem / 48px) to create a friendly, encapsulated look.
- **Buttons/Inputs:** Use `rounded-DEFAULT` (1rem / 16px) for a consistent, pill-like touch-target feel.
- **Avatars/Badges:** Utilize full-circle `rounded-full` to provide a distinct contrast against the larger container shapes.
- **Borders:** All borders are kept thin (1px to 2px) to maintain a precise, technical look despite the softer corners.

## Components
- **Buttons:** Primary buttons are outlined or filled with the brand color, featuring 14px bold text and pill-shaped corners. Secondary buttons for dangerous actions use a dark red wash with bold red text.
- **Toggles:** Use a pill-shaped track with a high-contrast white thumb. The track color changes to the primary brand color when active.
- **Metrics Cards:** Large-format numbers (24px) paired with uppercase, muted semantic labels, housed in highly rounded containers.
- **List Items:** Enclosed in a single card container with 1px `primary/10` dividers between items to reduce visual noise.
- **Badges:** Small, pill-shaped markers with uppercase text, used for status indicators like "Arqueólogo".
- **Bottom Navigation:** Clean icons with 10px bold uppercase labels, using color (Primary vs. Muted) to indicate active state against the dark background.
