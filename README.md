## xmake-repo 库索引

```typescript
export interface Package {
    supported_plats: { [key: string]: number };
    urls:            string[] | EmptyObject;
    description?:    string;
    versions:        string[] | EmptyObject;
    packagedir:      string;
    license?:        string[] | string;
    packagefile:     string;
    configs?:        { [key: string]: string[] | boolean | EmptyObject | number | string };
}

export type EmptyObject = {};

export interface Index {
    [key: name]: Package
}
```
