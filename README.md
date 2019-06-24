# maxscript_fix_jt_groups
Rename objects based on group name and convert to instances

When 3ds Max imports .jt files it creates a group for every single object, the group has the object name and the object gets a name with a  jt_obj_ prefix. 
It also doesn't create instances even though those are present in the .jt file.

This script has the following parameters defined near the top (1 means active, 0 means it will be skipped):

group_children_rename=1
This searches for groups containing an object with a "jt_obj_" prefix. It then removes the group and renames the object with the group name.

create_instances_from_identically_named_objects=0
This finds objects with the same name and converts them to be instances of the first one. 
Two different algoritms for this one:
1. do this across the entire scene
2. do this per group

WARNING: this is highly risky because it just checks that we do it on editable meshes with the same number of faces, v5 addes a check for the total face area. Use at your own risk!

make_all_instances_unique=0
Iterates through all objects and makes them unique
