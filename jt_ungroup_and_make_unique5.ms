all_jt_objs=#()
all_groups_to_remove=#()



-- set this to one to convert the objects to their group names
group_children_rename=1

-- set this to 1 or 2 to try to create instances
-- two options based on the same concept: every group that contains a jt_obj_*, the first one is retained, make the rest instances 
-- algoritm 1 : do this across the entire sceneMaterials
-- algortim 2: do this on a group by group basis
-- WARNING: this may have unintended consequences in case there are objects with the same name but different geometry
-- to reduce this risk only do it on objects with the same number of faces, still not a 100% guarantee!
-- also checks the total area of the faces matches, again not a 100% guarantee!
create_instances_from_identically_named_objects=2

-- set this to 1 to make all instance unique
make_all_instances_unique=0




if group_children_rename==1 then
(
	for o in objects do
	(
		if isGroupHead o do 
		(
			for i in o.children do
			(
				if (substring i.name 1 7)=="jt_obj_" then
				(
					append all_jt_objs i
					appendifunique all_groups_to_remove o
				)
			)
		)
	)

	--print all_jt_objs
	--print all_groups_to_remove

	-- first we rename all jt_objs
	for i in all_jt_objs do
	(
		a=i.parent.name
				
		-- rename as parent group
		i.name=a
	)
	
	
	-- then we ungroup them
	for i in all_groups_to_remove do
	(
		ungroup i
	)
)
	

if create_instances_from_identically_named_objects==1 then
(
	-- WARNING: this may have unintended consequences in case there are objects with the same name but different geometry
	-- to reduce this risk only do it on objects with the same number of faces, still not a 100% guarantee!
	
	d=#()
	-- merge objects with the same name in a group
	for o1 =1 to geometry.count do
	(
		-- we only want to do this in the geometry[o1] is not an instance already
		a=instancemgr.getinstances geometry[o1] &d
		if a==1 then
		(
			for o2 =(o1+1) to geometry.count do
			(
				if geometry[o1].name == geometry[o2].name then
				(
					-- only works on meshes
					if (classof geometry[o1])==Editable_mesh then
					(
						if (classof geometry[o2])==Editable_mesh then
						(
							if (meshop.getnumfaces geometry[o1]) == (meshop.getnumfaces geometry[o2]) then
							(
								f=#()
								for i = 1 to meshop.getnumfaces geometry[o1] do
								(
									append f i
								)
								if (meshop.getfacearea geometry[o1] f) == (meshop.getfacearea geometry[o2] f) then
								(
									instanceReplace geometry[o2] geometry[o1]
								)
							)
						)
					)
				)
			)
		)
	)
)

if create_instances_from_identically_named_objects==2 then
(
	-- WARNING: this may have unintended consequences in case there are objects with the same name but different geometry
	-- to reduce this risk only do it on objects with the same number of faces, still not a 100% guarantee!
	
	d=#()
	
	-- similar to the above but now we loop through the group's children instead of all geometry
	for o in objects do
	(
		if (isGroupHead o) do 
		(
			for o1 = 1 to o.children.count do
			(
				-- we only want to do this in the geometry[o1] is not an instance already
				a=instancemgr.getinstances o.children[o1] &d
				if a==1 then
				(
					for o2 = o1 to o.children.count do
					(
						if o.children[o1].name == o.children[o2].name then
						(
							if (classof o.children[o1])==Editable_mesh then
							(
								if (classof o.children[o2])==Editable_mesh then
								(	
									if (meshop.getnumfaces o.children[o1]) == (meshop.getnumfaces o.children[o2]) then
									(
										f=#()
										for i = 1 to meshop.getnumfaces o.children[o1] do
										(
											append f i
										)
										if (meshop.getfacearea o.children[o1] f) == (meshop.getfacearea o.children[o2] f) then
										(
											instanceReplace o.children[o2] o.children[o1]
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)
)


if make_all_instances_unique==1 then
(
 -- also check if objects are instamces amd make them unique
 for i in objects do
 (
  a=instancemgr.getinstances i &instances
  if a!=1 then
  (
   print i.name
   InstanceMgr.MakeObjectsUnique &instances #individual
  )
 )
)

format "\n"
