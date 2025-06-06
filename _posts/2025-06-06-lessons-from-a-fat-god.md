---
title: "Lessons from a FAT God"
layout: post
permalink: /posts/lessons-from-a-FAT-god
categories: 
    - Long Essay
    - Hardware
---
It's almost been 24 years since the shift of exFAT to NTFS on Windows XP, the greatest Windows to some and the last bastion of native FAT-family support on any Windows systems. While exFAT still persists in USB flash drives, boot partitions and *some* legacy partitions, FAT is mostly gone in the Windows space, being surpassed by NTFS yet it survives.

Everything from its (poor) attribute flags to data clustering has helped modern file systems heavily inspiring NTFS, hell, even Linux-favorites like ext4 and btrfs. The FAT family of file systems wasn't the widest-used file systems for two-and-a-half decades for a reason and its importance never falls short.

## The FAT12 era
FAT12 wasn't made just to store data, it was about making file systems portable and created a standard. It was a simple solution. Each file was stored as a chain of clusters, the FAT entry for each cluster pointed to the next cluster in the chain while a special value (usually `0xFFF`) marked the end of the file. This structure let FAT12 support files of varying length without preallocation, ushering the standard of "unallocated free space" for future file systems

Capped at around 4,000 usable data clusters, FAT12 was the first commercially used FAT past the 8-bit FAT which as FAT12 was the go-to system for floppy disks. Using 12-bits, FAT12 managed up to 4,084 clusters (without overhead). This aligned perfectly with the capacities of floppy disks. It replaced the earlier 8-bit FAT systems and became the [standard format for 360KB, 720KB and 1.44MB floppies.](https://en.wikipedia.org/wiki/Floppy_disk)

The layout of FAT12 was designed to fit within the physical constraints of floppy drives and the disk was organized using a boot sector, FAT #1 and FAT #2 copy sectors for redundancy, the root directory and the data area. But that meant FAT12 wasn't scalable. You couldn't grow a volume past 32MB and the limited number of clusters seriously [capped file organization](https://dankohn.info/projects/PromdiskIII/PCINTERN-chp21.pdf). No file organization, no subdirectories and only basic file attributes.

Well, you could see the issue with the structure described. One bad sector and it would be good riddance to your entire disk. This meant that it would also be a goodbye to scalability and speed. To access data in a sector you'd need to to traverse the linearly-implemented cluster chain. It wasn't much but it laid the groundwork for everything to come.
## The FAT16 era: Consoles and Cameras
FAT16 on the other hand was a commitment to serious storage. It brought in a broader vision of support for the rapidly expanding demand of hard disks, and a more robust layout that could stretch across megabytes of data without collapsing under its sheer size. FAT16 became prevalent with the rise of hard disks as size was the name of the game.

Similar to FAT12, FAT16 stored files as cluster chains with each entry in the table still pointing to the next cluster in the system at 16-bit values, allowing over 65,000 clusters per volume. Of course, it was still structurally similar but with more breathing room due to the larger file entry. 

FAT16 bought something revolutionary: it standardized how to format and organize hard disks. It enabled cross-device compatibility, making it possible for software and hardware vendors to agree on a common disk format. Think [Maxtor](https://alexandrugroza.ro/olddiscdrives/historical-ide-hdd/index.html#:~:text=Western%20Digital%20used%20a%20yellow,WD%20disc:%20fast%20and%20reliable). You could swap drives between machines. It paved the path for portability.

FAT16 got too close to the Sun, however. Scalability and size were the issue with FAT16. Files were still chained cluster-by-cluster and reading was *still* linear. Reading a fragmented file meant going on a spiritual quest to find the next fragment of data. Hard disks using FAT16 were **painfully** inefficient. As file sizes grew and the number of files ballooned, FAT16 hit its ceiling. Larger cluster sizes or switching to **FAT16B** (confusingly 32-bit) skyrocketed internal fragmentation. A 1KB file could waste up 31KB.

On top of that, the root directory's fixed sized bottlenecked the hard drive. Once you hit the limit on entries, you were done. You'd either start deleting files or rethink your directory layout. FAT16 couldn't dynamically grow its root directory. It couldn't support access control. It had no concept of journaling, long filenames or multiple user access but nevertheless made history. It ran the software of DOS, Windows 3.x, early Linux distros, embedded systems of the early-to-mid '90s, powering the golden era of the personal computer. 
## The FAT32 era: The last great FAT filesystem
The late 90s came with greater size and scalability requirements than before. FAT32 was necessary, and still is. It reworked the scalability of the FAT16 and FAT16B formats with its new cluster count at 4 million clusters per volume. 

At its core, FAT32 maintained the chain-of-clusters architecture. Every file was a linked list of clusters with the FAT table guiding access, just like before. But used 32-bit entries much like FAT16B, though only 28 bits were actually used for addressing and reversing the rest for control flags. This had a massive impact as while FAT16B maxed out at 2GB per volume, FAT32 could scale up to 2TB with 512B sectors to a maximum of 16TB with 4KB sectors and 64KB clusters.  

FAT32 still lacked the features of modern file systems, unless hacked with [DR-DOS](https://winworldpc.com/product/dr-dos/7x). But looking back, its disk layout was only slightly improved. The greatest difference was the root directory being no longer fixed in size, meaning it could now live anywhere in the data area, increasing a FAT32's system scalability. FAT32 also finally embraced [VFAT's Long File Names](http://justsolve.archiveteam.org/wiki/VFAT), allowing the handling of up to 255-charavter UCS-2 fiilenames, although under the hood, these were layered atop short filenames, using special directory entries.

However, in true Microsoft fashion, Windows NT bizarrely [capped FAT32](https://learn.microsoft.com/gl-es/previous-versions/windows/desktop/sidebar/system-shell-drive-driveformat) formatting to 32 GB volumes, even though the format could support terabytes. This artificial limitation was strategic. Microsoft wanted to nudge users toward NTFS, but FAT32 remained widely supported thanks to its lightweight implementation and universal compatibility.

Even as hard drives ballooned past hundreds of gigabytes, FAT32 refused to go away.
Bootable on everything from PCs to digital cameras, MP3 players, game consoles, embedded systems, and later, USB flash drives. If you needed ubiquity over power, FAT32 was your go-to. Support also grew in the shadows; DR-DOS, REAL/32, IBM’s 4690 OS, and even Nero’s FAT32.EXE driver brought the format into their ecosystems. But by the late 2000s, cracks showed.

The 4 GB file size limit began to hurt, think DVD images, HD videos, software packages. Workarounds like splitting files or switching to exFAT became common. The lack of robust security and no journaling made FAT32 vulnerable in large, active environments. And with SSDs and high-speed storage rising, the format’s non-aligned cluster architecture left performance on the table.

FAT32 may have not been the most elegant, modern or secure, but it outlasted its successors in sheet adoption and holds the title, in my books, as *the last great FAT file system*.
## The exFAT era
Where FAT32 has tried to stretch an aging file system in a rapidly developing environment, the Extended File Allocation Table (exFAT) let it set, finally lifting the weight of the FAT file system's limits. No more file caps and limited volumes, flash storage was the next thing to be supported with a system designed for floppy disks.

exFAT was a sleeper hit: [introduced in 2006 for Windows CE](https://learn.microsoft.com/en-us/windows/win32/fileio/exfat-specification) but it wasn't the default format for SDXC cards and larger-size USB drives that it took off. The purpose was straightforwards: build a file system optimized for flash media.

exFAT upscaled the file size limit up to 16EB while the volume size bubbled up to 128PB, but of course, artificial, OS-based caps reduced these limits in their implementations. exFAT also handled larger clusters more efficiently, which meant that overhead when reading or writing large files was reduced, the most embellished feature of exFAT.

Its layout was also streamlined. The boot sector contained exFAT-specific flags and fields, more flexible than the last-gen FAT boot sector solutions. exFAT skipped cluster tracking and replaced it entirely with bitmap-based allocation, enabling faster lookups and thus reduced overhead. Directory entries were structured in chunk and not fixed-size arrays, allowing exFAT to be more memory-efficient and scalable.

Again in true Microsoft fashion, exFAT was initially proprietary [(until 2019!)](https://opensource.microsoft.com/blog/2019/08/28/exfat-linux-kernel/). Linux and Android, by extension, could read it with reversed-engineered drivers, but was hampered by legal implications. 

It could be argued that this was because exFAT was a creation for ubiquity in a bid to replicate the success of FAT32. While the modernities of journaling, file permissions and metadata indexing never arrived, exFAT prioritized said ubiquity and convenience. Microsoft almost ensured that hardware manufacturers had to support it. Cameras, consoles, routers and Smart TVs all needed exFAT compatibility if they wanted to even have a chance of surviving. 

But for all its evolution exFAT isn't perfect. The intimacies of crash recovery from journaling, multi-user support from permissions and unsuitability for high-speed internal drives or complex data integrity demand, NTFS and ext4 still rule the modern needs of storage drives. Sure, exFAT didn't reinvent anything and was never used as the main file system of any Microsoft-backed OS but it did drive portable technology forward in the mid-to-late 2000s.

While none of the FAT variants were perfect, they laid the foundation for modern file system design, creating the standards for data layout and portability that created the backbone for decades of computing. 
