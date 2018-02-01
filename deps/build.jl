using BinaryProvider

# This is where all binaries will get installed
const prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__,"usr"))

libcspice = LibraryProduct(prefix, "libcspice")

products = [libcspice]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaAstro/SPICEBuilder/releases/download/N0066"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    BinaryProvider.Linux(:aarch64, :glibc) => ("$bin_prefix/cspice.aarch64-linux-gnu.tar.gz", "fd40723cd299e89d8f86879eeebd99ff7c56e079b90fc56f8a5eda8915c3c123"),
    BinaryProvider.Linux(:armv7l, :glibc) => ("$bin_prefix/cspice.arm-linux-gnueabihf.tar.gz", "ae7bd048f7b755cd45f0e721618e083f9f6e6be7fd5f903236b85770bbc84e0a"),
    BinaryProvider.Linux(:i686, :glibc) => ("$bin_prefix/cspice.i686-linux-gnu.tar.gz", "0f4b85a860463f70b16c5c85e226100df2d0ecebb3c671023e4e95fcdd0014e5"),
    BinaryProvider.Windows(:i686) => ("$bin_prefix/cspice.i686-w64-mingw32.tar.gz", "a37ee30d85b50483ae559f8349387fb793ab6ba67460984c4b431bbff3532d8f"),
    BinaryProvider.Linux(:powerpc64le, :glibc) => ("$bin_prefix/cspice.powerpc64le-linux-gnu.tar.gz", "58e3175a03f40d7639862f451ae9cd20ffe490be226277018e09236f0f293119"),
    BinaryProvider.MacOS() => ("$bin_prefix/cspice.x86_64-apple-darwin14.tar.gz", "552b0ac9bdce1785e2c171cf09ff75f4debf3b664812198259e855fc9439f225"),
    BinaryProvider.Linux(:x86_64, :glibc) => ("$bin_prefix/cspice.x86_64-linux-gnu.tar.gz", "6b40a00766d9840254c1ece74d1d846f7a80d914ae2cf3a187c179fe46cbcd5f"),
    BinaryProvider.Windows(:x86_64) => ("$bin_prefix/cspice.x86_64-w64-mingw32.tar.gz", "c83b25a30f6e0f76e746eeef4dcbfd4d2c7adb82456eae34a82bde4a4a1064ec"),
)
if platform_key() in keys(download_info)
    # First, check to see if we're all satisfied
    if any(!satisfied(p; verbose=true) for p in products)
        # Download and install binaries
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end

    @write_deps_file libcspice
else
    error("Your platform $(Sys.MACHINE) is not supported by this package!")
end
