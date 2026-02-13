---
name: gryffindor-house
description: Frontend & User Experience specialist team. Use when building UI components, styling, animations, accessibility features, or any user-facing work. Triggers on "frontend", "UI", "UX", "component", "CSS", "React", "Vue", "Angular", "design system", "responsive", "animation", "accessibility", "WCAG", "layout", "theme".
---

# Gryffindor House - Frontend & User Experience

> **Values**: Courage, user-facing bravery, bold design decisions
> **Domain**: Everything the user sees and interacts with

## House Professors (Agent Roles)

### UI Architect
- Component design and structure
- State management patterns
- Routing and navigation
- Design system implementation

### Visual Designer
- CSS architecture
- Animations and transitions
- Responsive layouts
- Theme systems (light/dark mode)
- Visual polish

### Accessibility Specialist
- ARIA implementation
- Keyboard navigation
- Screen reader optimization
- WCAG compliance
- Color contrast and visibility

### Performance Optimizer
- Bundle size optimization
- Lazy loading strategies
- Render optimization
- Image optimization
- Core Web Vitals

### UX Researcher
- User flow analysis
- Interaction patterns
- Usability testing support
- Error state handling

---

## Architectural Patterns

### Component Structure
```
components/
├── ui/              # Primitive components (Button, Input, Card)
├── features/        # Feature-specific components
├── layouts/         # Page layouts and containers
└── shared/          # Cross-feature shared components
```

### Naming Conventions
- Components: PascalCase (`UserProfile.tsx`)
- Hooks: camelCase with `use` prefix (`useAuth.ts`)
- Utils: camelCase (`formatDate.ts`)
- Styles: Component-adjacent (`UserProfile.module.css`)

### State Management Hierarchy
1. **Local state**: Component-specific, use `useState`
2. **Shared state**: Feature-level, use Context or prop drilling
3. **Global state**: App-wide, use designated state library
4. **Server state**: API data, use query library (React Query, SWR)

---

## Decision Log

### [Template - Copy for new decisions]
```markdown
### Decision: [Title]
**Date**: [YYYY-MM-DD]
**Decided by**: [Agent]
**Year Level**: [1/3/5/7]

**Context**: [Why this decision was needed]

**Options Considered**:
1. [Option A] - [Pros/Cons]
2. [Option B] - [Pros/Cons]

**Decision**: [What we chose]

**Rationale**: [Why]

**Impact**: [What this affects]
```

---

## Contracts We Publish

### Component Contracts
Location: `contracts/component-contracts/`

What we define:
- Component props and types
- Event handlers and callbacks
- Styling customization API
- Accessibility requirements

### Consumed Contracts
- API contracts from Ravenclaw (data shapes)
- Test contracts from Slytherin (what to test)
- Deploy contracts from Hufflepuff (build requirements)

---

## Quality Checklist

Before marking any task complete:

### Functionality
- [ ] Component renders correctly
- [ ] All props work as documented
- [ ] Edge cases handled (empty states, loading, errors)
- [ ] Responsive on all breakpoints

### Accessibility
- [ ] Keyboard navigable
- [ ] Screen reader tested
- [ ] Color contrast passes WCAG AA
- [ ] Focus states visible

### Performance
- [ ] No unnecessary re-renders
- [ ] Images optimized
- [ ] Bundle impact assessed

### Code Quality
- [ ] TypeScript types complete
- [ ] No console errors/warnings
- [ ] Follows naming conventions
- [ ] Contract updated if interface changed

---

## Common Patterns

### Loading States
```typescript
if (isLoading) return <Skeleton />;
if (error) return <ErrorState error={error} />;
if (!data) return <EmptyState />;
return <Content data={data} />;
```

### Error Boundaries
Wrap feature components in error boundaries to prevent cascade failures.

### Responsive Approach
Mobile-first: Start with mobile layout, add complexity for larger screens.

---

## Anti-Patterns to Avoid

- ❌ Inline styles for complex styling
- ❌ Direct DOM manipulation
- ❌ Ignoring accessibility
- ❌ Prop drilling more than 2 levels
- ❌ Massive monolithic components
- ❌ CSS `!important` abuse
- ❌ Hardcoded colors/spacing (use design tokens)

---

## House Points Bonuses

Gryffindor earns bonus points for:
- +5: Accessibility excellence (perfect WCAG compliance)
- +3: Performance improvement (measurable CWV gain)
- +3: Design system contribution
- +2: Cross-browser compatibility handling
