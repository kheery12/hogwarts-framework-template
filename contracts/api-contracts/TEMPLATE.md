# API Contract Template

Copy this template for new API contracts.

---

## Contract: [Endpoint/Feature Name]

**Version**: 1.0.0
**Author**: Ravenclaw/[Agent]
**Consumers**: [List Houses/Agents that will use this]
**Status**: Draft | Review | Approved | Deprecated

---

### Endpoint

**Method**: [GET/POST/PUT/PATCH/DELETE]
**Path**: `/api/v1/[resource]`
**Authentication**: [Required/Optional/None]
**Authorization**: [Role requirements]

---

### Request

**Headers**:
```
Authorization: Bearer [token]
Content-Type: application/json
```

**Query Parameters** (for GET):
| Param | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| page | number | No | 1 | Page number |
| limit | number | No | 20 | Items per page |

**Body** (for POST/PUT/PATCH):
```json
{
  "field1": "string (required) - Description",
  "field2": "number (optional) - Description",
  "nested": {
    "field3": "boolean (required) - Description"
  }
}
```

**TypeScript Type**:
```typescript
interface RequestBody {
  field1: string;
  field2?: number;
  nested: {
    field3: boolean;
  };
}
```

---

### Response

**Success (200/201)**:
```json
{
  "success": true,
  "data": {
    "id": "string",
    "field1": "string",
    "createdAt": "ISO8601 timestamp"
  },
  "meta": {
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100
    }
  }
}
```

**TypeScript Type**:
```typescript
interface ResponseData {
  id: string;
  field1: string;
  createdAt: string;
}

interface SuccessResponse {
  success: true;
  data: ResponseData;
  meta?: {
    pagination?: PaginationMeta;
  };
}
```

---

### Errors

| Code | Error Code | Description | Resolution |
|------|------------|-------------|------------|
| 400 | VALIDATION_ERROR | Invalid request body | Check required fields |
| 401 | UNAUTHORIZED | Missing/invalid token | Provide valid auth token |
| 403 | FORBIDDEN | Insufficient permissions | Check user role |
| 404 | NOT_FOUND | Resource doesn't exist | Verify ID |
| 500 | INTERNAL_ERROR | Server error | Contact backend team |

**Error Response Format**:
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human readable message",
    "details": [
      {
        "field": "field1",
        "message": "Field is required"
      }
    ]
  }
}
```

---

### Rate Limits

| Scope | Limit | Window |
|-------|-------|--------|
| Per user | 100 requests | 1 minute |
| Per IP | 1000 requests | 1 minute |

---

### Examples

**Request**:
```bash
curl -X POST https://api.example.com/api/v1/resource \
  -H "Authorization: Bearer token123" \
  -H "Content-Type: application/json" \
  -d '{"field1": "value", "nested": {"field3": true}}'
```

**Response**:
```json
{
  "success": true,
  "data": {
    "id": "abc123",
    "field1": "value",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

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
