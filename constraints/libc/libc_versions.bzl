GLIBC_VERSIONS = [
    "2.17",
    "2.18",
    "2.19",
    "2.20",
    "2.21",
    "2.22",
    "2.23",
    "2.24",
    "2.25",
    "2.26",
    "2.27",
    "2.28",
    "2.29",
    "2.30",
    "2.31",
    "2.32",
    "2.33",
    "2.34",
    "2.35",
    "2.36",
    "2.37",
    "2.38",
    "2.39",
    "2.40",
    "2.41",
    "2.42",
    "2.43",
    "2.44",
]

GLIBCS = ["gnu.{}".format(glibc) for glibc in GLIBC_VERSIONS]

LIBCS = ["musl"] + GLIBCS

DEFAULT_LIBC = "gnu.2.28"

# compile-rt from LLVM requires kernel headers >= 5.10 for RISC-V.
# Keep RISC-V on a libc whose default linux UAPI headers satisfy that.
DEFAULT_LIBCS = {
    ("linux", "riscv64"): "gnu.2.33",
    ("linux", "loongarch64"): "gnu.2.36",
}

def default_libc(target_os, target_cpu):
    return DEFAULT_LIBCS.get((target_os, target_cpu), DEFAULT_LIBC)

def glibc_supported(target_cpu, version):
    """Whether this architecture has sources and headers for the glibc release."""
    # The 2.42-20251210 headers release has no LoongArch archive.
    if target_cpu == "loongarch64" and version == "2.42":
        return False

    minimum_version = {
        "riscv64": (2, 27),
        "loongarch64": (2, 36),
    }.get(target_cpu)
    return minimum_version == None or tuple([int(part) for part in version.split(".")]) >= minimum_version
