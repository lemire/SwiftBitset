#include <stdint.h>

#if __SIZEOF_LONG_LONG__ != 8
#error This code assumes  64-bit long longs (by use of the GCC intrinsics). Your system is not currently supported.
#endif

#if  defined(__x86_64__) || defined(_M_X64)
// we have an x64 processor
// we include the intrinsic header
#ifdef _MSC_VER
/* Microsoft C/C++-compatible compiler */
#include <intrin.h>
#else
/* Pretty much anything else. */
#include <x86intrin.h> // on some recent GCC, this will declare posix_memalign
#endif
#endif

static inline int hamming(uint64_t x) {
#if defined(__POPCNT__)
    return _mm_popcnt_u64(x);
#else
    // won't work under visual studio, but hopeful we have _mm_popcnt_u64 in
    // many cases
    return __builtin_popcountll(x);
#endif
}

static inline int trailing(uint64_t x) {
#if defined(__BMI1__)
    return _mm_tzcnt_64(x);
#else
    // won't work under visual studio, but hopeful we have _mm_popcnt_u64 in
    // many cases
    return __builtin_ctzll(x);
#endif
}


