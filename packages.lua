-- imports
import("core.base.semver")
import("core.package.package")
import("core.platform.platform")
import("private.core.base.select_script")

-- is supported platform and architecture?
function is_supported(instance, plat, arch, opt)
    opt = opt or {}
    if instance:is_template() then
        return false
    end

    local script = instance:get(instance:is_fetchonly() and "fetch" or "install")
    if not select_script(script, {
        plat = plat,
        arch = arch
    }) then
        if opt.native and select_script(script, {
            plat = plat,
            arch = arch,
            subhost = plat,
            subarch = arch
        }) then
            return true
        end
        return false
    end
    return true
end

-- load package
function _load_package(packagename, packagedir, packagefile)
    local funcinfo = debug.getinfo(package.load_from_repository)
    if funcinfo and funcinfo.nparams == 3 then -- >= 2.7.8
        return package.load_from_repository(packagename, packagedir, {
            packagefile = packagefile
        })
    else
        -- deprecated
        return package.load_from_repository(packagename, nil, packagedir, packagefile)
    end
end

function _sort_versions(versions)
    table.sort(versions, function(a, b)
        return semver.compare(a, b) > 0
    end)
    return versions
end

-- the main entry
function main(opt)
    opt = opt or {}
    local packages = {}
    for _, packagedir in ipairs(os.dirs(path.join("packages", "*", "*"))) do
        local packagename = path.filename(packagedir)
        local packagefile = path.join(packagedir, "xmake.lua")
        local instance = _load_package(packagename, packagedir, packagefile)
        local basename = instance:get("base")
        if instance and basename then
            local basedir = path.join("packages", basename:sub(1, 1):lower(), basename:lower())
            local basefile = path.join(basedir, "xmake.lua")
            instance._BASE = _load_package(basename, basedir, basefile)
        end
        if instance then
            local supported_plats = {}
            for _, plat in ipairs({"windows", "linux", "macosx", "iphoneos", "android", "mingw", "msys", "bsd", "wasm",
                                   "cross"}) do
                local archs = platform.archs(plat)
                if archs then
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

                    local arch_num = 0
                    for _, arch in ipairs(archs) do
                        local arch_num_tmp = archs_str_to_num[arch]
                        if is_supported(instance, plat, arch, opt) then
                        if arch_num_tmp then
                            arch_num = arch_num + archs_str_to_num[arch]
                        else
                            print("error: unknown architecture %s", arch)
                        end
                        end
                    end

                    supported_plats[plat] = arch_num

                    local name = instance:name()
                    packages[name] = {}
                    packages[name].urls = instance:urls()
                    packages[name].versions = _sort_versions(instance:versions())
                    packages[name].supported_plats = supported_plats
                    packages[name].configs = instance:configs()
                    packages[name].deps = instance:orderdeps()
                    packages[name].description = instance:description()
                    packages[name].license = instance:license()
                    packages[name].packagefile = packagefile
                    packages[name].packagedir = packagedir
                end
            end
        end
    end
    import("core.base.json").savefile("index.json", packages)
end
