# Sorting Hat Cache

> Remembering which agents excel at which tasks.

**Last Updated**: [Timestamp]

---

## Task Type Performance

### Authentication & Authorization
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

### API Development
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

### UI Components
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

### Database Work
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

### Testing
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

### Security Audit
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

### DevOps/Deployment
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

### Documentation
**Best Performers**:
1. [Agent] - [House] (Quality: -, Efficiency: -)
2. [Agent] - [House] (Quality: -, Efficiency: -)

**Recent Missions**:
| Date | Agent | Quality | Efficiency |
|------|-------|---------|------------|
| - | - | - | - |

---

## Cache Maintenance

### Update Rules
- Add entry after each mission completion
- Keep last 20 entries per task type
- Recalculate "Best Performers" on each update
- Weight recent performance higher (decay factor 0.9)

### Decay Formula
```
Weighted Score = Score × (0.9 ^ months_old)
```

### Cache Purge
- Remove entries older than 6 months
- Archive to `logs/house-cup/archive/` if needed for reference
