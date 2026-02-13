# Component Contract Template

Copy this template for new component contracts.

---

## Contract: [ComponentName]

**Version**: 1.0.0
**Author**: Gryffindor/[Agent]
**Consumers**: [List Houses/Agents that will use this]
**Status**: Draft | Review | Approved | Deprecated

---

### Overview

**Purpose**: [What this component does]
**Location**: `src/components/[path]/[ComponentName].tsx`

---

### Props Interface

```typescript
interface [ComponentName]Props {
  /** Required: Description */
  requiredProp: string;

  /** Optional: Description. Default: defaultValue */
  optionalProp?: number;

  /** Callback when X happens */
  onAction?: (value: string) => void;

  /** Children content */
  children?: React.ReactNode;
}
```

### Props Table

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| requiredProp | string | Yes | - | Description |
| optionalProp | number | No | 0 | Description |
| onAction | function | No | - | Callback when X |
| children | ReactNode | No | - | Child content |

---

### Usage Examples

**Basic**:
```tsx
<ComponentName requiredProp="value" />
```

**With all props**:
```tsx
<ComponentName
  requiredProp="value"
  optionalProp={42}
  onAction={(val) => console.log(val)}
>
  <ChildContent />
</ComponentName>
```

**In context**:
```tsx
function ParentComponent() {
  const handleAction = (value: string) => {
    // Handle the action
  };

  return (
    <div>
      <ComponentName
        requiredProp="value"
        onAction={handleAction}
      />
    </div>
  );
}
```

---

### States

**Loading**:
```tsx
<ComponentName requiredProp="value" isLoading />
```

**Error**:
```tsx
<ComponentName requiredProp="value" error="Error message" />
```

**Empty**:
```tsx
<ComponentName requiredProp="value" data={[]} />
```

**Disabled**:
```tsx
<ComponentName requiredProp="value" disabled />
```

---

### Styling

**CSS Classes**:
| Class | Purpose |
|-------|---------|
| `.component-name` | Root element |
| `.component-name--variant` | Variant modifier |
| `.component-name__child` | Child element |

**CSS Variables** (customization):
| Variable | Default | Description |
|----------|---------|-------------|
| `--component-bg` | `#fff` | Background color |
| `--component-border` | `#ddd` | Border color |

**Customization Example**:
```tsx
<ComponentName
  requiredProp="value"
  className="my-custom-class"
  style={{ '--component-bg': '#f0f0f0' }}
/>
```

---

### Accessibility

| Requirement | Implementation |
|-------------|----------------|
| Keyboard nav | [How implemented] |
| Screen reader | [ARIA labels used] |
| Focus management | [How focus is handled] |
| Color contrast | [WCAG level met] |

---

### Events

| Event | Payload | Description |
|-------|---------|-------------|
| onAction | `string` | Fired when X happens |
| onChange | `{ value: T }` | Fired when value changes |
| onError | `Error` | Fired on error |

---

### Dependencies

**Internal**:
- `Button` component
- `useAuth` hook

**External**:
- None / [List any]

---

### Testing

**Required Tests**:
- [ ] Renders with required props
- [ ] Handles optional props correctly
- [ ] Fires events appropriately
- [ ] Accessible (keyboard, screen reader)
- [ ] Handles edge cases (empty, error, loading)

**Test File**: `src/components/[path]/[ComponentName].test.tsx`

---

### Questions

[Consumers can add questions here, authors respond]

- Q: [Question]?
  - A: [Answer]

---

### Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | [Date] | [Author] | Initial contract |
