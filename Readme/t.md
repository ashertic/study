/dev/nvme0n1p1      2048    411647    409600   200M EFI System
/dev/nvme0n1p2    411648  33966079  33554432    16G Linux swap
/dev/nvme0n1p3  33966080 159795199 125829120    60G Linux filesystem
/dev/nvme0n1p4 159795200 468862094 309066895 147.4G Linux filesystem

/dev/nvme1n1p1      2048 314574847 314572800   150G Linux filesystem
/dev/nvme1n1p2 314574848 976773134 662198287 315.8G Linux filesystem

cat > script.sh <<EOF
mkfs.vfat /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mkfs.ext4 /dev/nvme0n1p4
mkfs.ext4 /dev/nvme1n1p1
mkfs.ext4 /dev/nvme1n1p2

mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot/efi
mkdir -p /mnt/home
mkdir -p /mnt/var
mkdir -p /mnt/data

mount /dev/nvme0n1p1 /mnt/boot/efi
mount /dev/nvme0n1p4 /mnt/home
mount /dev/nvme1n1p1 /mnt/var
mount /dev/nvme1n1p2 /mnt/data
EOF