Zelda II Lag Reduction Patch
v0.1

By Justin Olbrantz (Quantam)

This patch optimizes several Z2 functions to significantly reduce CPU usage and thus the potential for lag. Changes that apply to the overworld reduce CPU usage by up to 7% and changes that apply to side-scrolling reduce CPU usage by up to 9%. These reductions have a very noticeable impact on the occurrence of lag, with some of the laggiest areas in the game being reduced to only mildly laggy.

REQUIREMENTS

Zelda II - The Adventure of Link (USA):
ROM CRC32 BA322865 / MD5 88C0493FB1146834836C0FF4F3E06E45
File CRC32 E3C788B0 / MD5 764D36FA8A2450834DA5E8194281035A

PATCHING

While the easiest way to patch is to simply use the online patcher for the romhack site if available, offline patching can be done with an IPS patching utility such as Lunar IPS.

COMPATIBILITY

This lag reduction patch can be used with other hacks provided the changes do not overlap. However, the source code is available on GitHub as well and can be adapted as necessary if the IPS does not play nicely with other changes.

This patch uses the following ROM ranges that were previously free:
- 1f28f-1f2c3
- 1ff5c-1ff7f

As well, it modifies the following ranges:
- 1e011-1e013
- 1e025-1e02a

PRODUCING DERIVATIVE HACKS

If you use this patch in other hacks, please include a credit for its use wherever other hack credits are listed.

LINKS

z2lagpatch GitHub Repository: https://github.com/TheRealQuantam/z2lagpatch
