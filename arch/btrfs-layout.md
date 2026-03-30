# TODO
- this is out of date
- continue to edit this file match the reality
- provide explanation for each choice, why am i doing this?

# Btrfs layout for efficient snapshoting
The goal here is to document my own choice for workstation/gaming

## root layout /
| subvol | path   | mount opt     | snapshot opt | comment                 |
| ------ | ------ | ------------- | ------------ | ----------------------- |
| @root  | /      |               | 50, boot     | snapshot number feeling |
| @home  | /home  | compress=zstd | 20, week,day | snapshot number feeling |
| @var   | /var   | compress=zstd |              |                         |

Swap ist not part of it, i think it's simpler to manage with another partition

## home layout /home
| subvol      | path in /home/${user} | mount opt               | snapshot opt | comment                                                                                                                          |
| ----------- | --------------------- | ----------------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| @project    | project               |                         | 8, hour      | contain work stuff and all git                                                                                                   |
| @steam      | .local/share/Steam    | nodatacow,compress=zstd |              |                                                                                                                                  |
| @home_cache | [SWAP]                | nodatacow               |              |                                                                                                                                  |
| @downloads  | downloads             | compress=zstd           |              |                                                                                                                                  |
| @home_other | .no_snaptshot         | nodatacow               |              | at some point if any other directory need to be moved out of home snapshot it could me placed here are refrecenced with sym link |

# links
- https://www.jwillikers.com/btrfs-layout
