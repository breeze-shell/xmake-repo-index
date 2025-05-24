## xmake-repo 库索引

#### 类型定义
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

#### 平台枚举
```typescript
// Original mapping from architecture names to bit values
const archsStrToNum: Record<string, number> = {
    "arm": 1 << 0,
    "arm64ec": 1 << 1,
    "mips64el": 1 << 2,
    "mips": 1 << 3,
    "riscv": 1 << 4,
    "sh4": 1 << 5,
    "ppc64": 1 << 6,
    "armeabi-v7a": 1 << 7,
    "ppc": 1 << 8,
    "x86_64": 1 << 9,
    "s390x": 1 << 10,
    "armv7": 1 << 11,
    "mip64": 1 << 12,
    "mips64": 1 << 13,
    "loong64": 1 << 14,
    "arm64": 1 << 15,
    "wasm64": 1 << 16,
    "x86": 1 << 17,
    "wasm32": 1 << 18,
    "x64": 1 << 19,
    "mipsel": 1 << 20,
    "armv7s": 1 << 21,
    "armeabi": 1 << 22,
    "arm64-v8a": 1 << 23,
    "i386": 1 << 24,
    "riscv64": 1 << 25
};

// Reverse enum for looking up architecture names from bit values
const archsNumToStr: Record<number, string> = Object.fromEntries(
    Object.entries(archsStrToNum).map(([key, value]) => [value, key])
);

// Lua version as a comment for reference
/*
local archs_str_to_num = {
    arm = 1 << 0,
    arm64ec = 1 << 1,
    mips64el = 1 << 2,
    mips = 1 << 3,
    riscv = 1 << 4,
    sh4 = 1 << 5,
    ppc64 = 1 << 6,
    ["armeabi-v7a"] = 1 << 7,
    ppc = 1 << 8,
    x86_64 = 1 << 9,
    s390x = 1 << 10,
    armv7 = 1 << 11,
    mip64 = 1 << 12,
    mips64 = 1 << 13,
    loong64 = 1 << 14,
    arm64 = 1 << 15,
    wasm64 = 1 << 16,
    x86 = 1 << 17,
    wasm32 = 1 << 18,
    x64 = 1 << 19,
    mipsel = 1 << 20,
    armv7s = 1 << 21,
    armeabi = 1 << 22,
    ["arm64-v8a"] = 1 << 23,
    i386 = 1 << 24,
    riscv64 = 1 << 25
}
*/
```
